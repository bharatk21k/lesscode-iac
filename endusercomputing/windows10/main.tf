data "aws_ecs_cluster" "ecs" {
  cluster_name = "${var.user_domain_name}-cluster"

}

data "aws_vpc" "vpc" {
  tags = {
    Name = var.user_domain_name
  }
}

data "aws_subnet_ids" "public" {
 vpc_id = data.aws_vpc.vpc.id
 filter {
    name = "tag:Name"
    values = ["${var.user_domain_name}"] 
 }
}

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.user_domain_name}-${var.user}-windows10-${lower(var.region)}"  
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}

data "template_file" "windows-userdata" {
  template = <<EOF
<powershell>
Rename-Computer -NewName "${var.windows_instance_name}" -Force;
$service = get-wmiObject -query 'select * from SoftwareLicensingService'
if($key = $service.OA3xOriginalProductKey){
  Write-Host 'Activating using product Key:' $service.OA3xOriginalProductKey
  $service.InstallProductKey($key)
}
else
{
  Write-Host 'Key not found., using Volume license'
  $service.InstallProductKey('VOLUME LICENSE KEY')
}
$Localuseraccount = @{
   Name = 'AdminUser'
   Password = ("Admin@1231" | ConvertTo-SecureString -AsPlainText -Force)
   AccountNeverExpires = $true
   PasswordNeverExpires = $true
   Verbose = $true
}
New-LocalUser @Localuseraccount
Add-LocalGroupMember -Group "Administrators" -Member "AdminUser"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "AdminUser"
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Install-WindowsFeature -name Web-Server -IncludeManagementTools;
shutdown -r -t 10;
</powershell>
EOF
}

#Create EC2 Instance
resource "aws_instance" "windows10" {
  ami                         = "ami-03bcb434b3d4de60d"
  instance_type               = var.windows_instance_type
  subnet_id                   = "subnet-08e058374b4f9ba9a" 
  vpc_security_group_ids      = [aws_security_group.aws-windows10-sg.id]
  associate_public_ip_address = var.windows_associate_public_ip_address
  source_dest_check           = false
  key_name                    = aws_key_pair.key_pair.key_name
  user_data                   = data.template_file.windows-userdata.rendered
  
  root_block_device {
    volume_size           = var.windows_root_volume_size
    volume_type           = var.windows_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.windows_data_volume_size
    volume_type           = var.windows_data_volume_type
    encrypted             = true
    delete_on_termination = true
  }
  
  tags = {
    Name        = "${var.user_domain_name}-${var.user}-windows10"
    Environment = var.env
  }
}

# Create Elastic IP for the EC2 instance
resource "aws_eip" "windows-eip" {
  vpc  = true
  tags = {
    Name        = "${var.user_domain_name}-${var.user}-windows10-eip"
    Environment = var.env
  }
}

# Associate Elastic IP to Windows Server
resource "aws_eip_association" "windows-eip-association" {
  instance_id   = aws_instance.windows10.id
  allocation_id = aws_eip.windows-eip.id
}

# Define the security group for the Windows server
resource "aws_security_group" "aws-windows10-sg" {
  name        = "${var.user_domain_name}-${var.user}-windows10-sg"
  description = "Allow incoming connections"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming RDP connections"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.user_domain_name}-${var.user}-windows10-sg"
    Environment = var.env
  }
}

