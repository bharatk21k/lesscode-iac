variable "region" {
    type = string
}

variable "env" {
  type        = string
  description = "env name"
}

variable "user" {
  type        = string
  description = "End user name"
}

variable "user_domain_name" {
  type        = string
  description = "user_domain_name"
}

variable "windows_instance_type" {
  type        = string
  description = "EC2 instance type for Windows 10"
}

variable "windows_associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address to the EC2 instance"
  default     = true
}

variable "windows_root_volume_size" {
  type        = number
  description = "Volumen size of root volumen of Windows 10"
}

variable "windows_data_volume_size" {
  type        = number
  description = "Volumen size of data volumen of Windows 10"
}

variable "windows_root_volume_type" {
  type        = string
  description = "Volumen type of root volumen of Windows 10. Can be standard, gp3, gp2, io1, sc1 or st1"
  default     = "gp2"
}

variable "windows_data_volume_type" {
  type        = string
  description = "Volumen type of data volumen of Windows 10. Can be standard, gp3, gp2, io1, sc1 or st1"
  default     = "gp2"
}

variable "windows_instance_name" {
  type        = string
  description = "EC2 instance name for Windows 10"
}
