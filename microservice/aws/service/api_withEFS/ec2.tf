resource "random_id" "creation_token" {
  byte_length = 8
  prefix      = "${var.name}"
}

resource "tls_private_key" "efs" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}

resource "aws_key_pair" "user-ssh-key" {
  key_name   = "efs-mount-key"
  public_key = tls_private_key.efs.public_key_openssh
  provisioner "local-exec" {
    command = "sudo echo '${tls_private_key.efs.private_key_pem}' > $HOME/lesscode-iac/microservice/aws/service/api_withEFS/${var.ecs_cluster_name}-efs-ec2-new.pem"
  }
}

resource "local_file" "ssh_key" {
  filename = "${var.ecs_cluster_name}-efs-ec2-new.pem"
  content = tls_private_key.efs.private_key_pem
}

resource "aws_instance" "efs" {
  count = 1
  ami = "ami-04ac2541df4955fb1"
  subnet_id = tolist(data.aws_subnet_ids.public.ids)[count.index]
  vpc_security_group_ids = [
    aws_security_group.efs-ec2.id,
    aws_security_group.mount_target_client.id,
    aws_security_group.mount_target.id
  ]

  instance_type          = "p3.2xlarge"
  key_name = aws_key_pair.user-ssh-key.key_name
  provisioner "local-exec" {
   command = "echo ${aws_instance.efs[0].public_ip} > $HOME/${var.ecs_cluster_name}-efs-ec2-publicIP.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /data",
      "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/ /data",
      "sudo su -c \"echo '${aws_efs_file_system.efs.dns_name}:/ /data nfs4 defaults,vers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 0 0' >> /etc/fstab\"",
      "sudo chmod go+rw /data"
    ]
  }

 connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.efs.private_key_pem
  }
    tags = {
      Name    = "${var.ecs_cluster_name}-${var.service_name}-ec2"
  }
}
