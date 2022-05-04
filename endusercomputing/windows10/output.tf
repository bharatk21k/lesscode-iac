output "public_subnets" {
    description = "Public Subnets"
    value = [data.aws_subnet_ids.public.ids]
}

output "vm_windows_server_instance_name" {
  value = var.windows_instance_name
}

output "vm_windows_server_instance_id" {
  value = aws_instance.windows10.id
}

output "vm_windows_server_instance_public_dns" {
  value = aws_instance.windows10.public_dns
}

output "vm_windows_server_instance_public_ip" {
  value = aws_eip.windows-eip.public_ip
}

output "vm_windows_server_instance_private_ip" {
  value = aws_instance.windows10.private_ip
}
