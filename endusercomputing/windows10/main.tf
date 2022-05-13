# network.tf
# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.env}-${var.customer_name}-${var.windows_instance_name}-windows10-vpc"
    Environment = var.env
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.aws_az
  tags = {
    Name        = "${var.env}-${var.customer_name}-${var.windows_instance_name}-windows10-psub"
    Environment = var.env
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.env}-${var.customer_name}-${var.windows_instance_name}-windows10-gw"
    Environment = var.env
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name        = "${var.env}-${var.customer_name}-${var.windows_instance_name}-windows10-rt"
    Environment = var.env
  }
}

resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.customer_name}-${var.windows_instance_name}-windows10-${lower(var.region)}"  
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
Write-Host 'Installing The Product Key...'
$service.InstallProductKey('${var.product_key}')
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
  subnet_id                   = aws_subnet.public-subnet.id 
  vpc_security_group_ids      = [aws_security_group.aws-windows10-sg.id]
  associate_public_ip_address = var.windows_associate_public_ip_address
  source_dest_check           = false
  key_name                    = aws_key_pair.key_pair.key_name
  user_data                   = data.template_file.windows-userdata.rendered
  
  root_block_device {
    volume_size           = var.windows_root_volume_size
    volume_type           = var.windows_root_volume_type
    delete_on_termination = true
    encrypted             = false
  }

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.windows_data_volume_size
    volume_type           = var.windows_data_volume_type
    encrypted             = true
    delete_on_termination = false
  }
  
  tags = {
    Name        = "${var.env}-${var.customer_name}-${var.windows_instance_name}-windows10"
    Environment = var.env
  }
}

# Create Elastic IP for the EC2 instance
resource "aws_eip" "windows-eip" {
  vpc  = true
  tags = {
    Name        = "${var.env}-${var.customer_name}-${var.windows_instance_name}-windows10-eip"
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
  name        = "${var.customer_name}-${var.windows_instance_name}-windows10-sg"
  description = "Allow incoming connections"
  vpc_id      = aws_vpc.vpc.id

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
    Name        = "${var.env}-${var.customer_name}-${var.windows_instance_name}-windows10-sg"
    Environment = var.env
  }
}
