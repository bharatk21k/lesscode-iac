variable "env" {
    type = string
}

variable "domain" {
    type =  string
}

variable "ecs_cluster_name" {
    type = string
}

variable "service_name" {
    type = string
}

variable "tls_port" {
   description = "HTTPS Secure port"
}

variable "pingdom_api_token" {
   type = string
   description = "API Token Generated from Pingdom Account"
}

variable "url" {
   type = string
   description = "Health Check Path of the Service"
}

variable "integrationids" {
   type = list
   description = "Team Ids of Pingdom Notifications"
}

variable "userids" {
   type = list
   description = "User Ids of the Pingdom Notifications"
}

variable "teamids" {
   type = list
   description = "Team Ids of Pingdom Notifications"
}

variable "enabled" {
  type = string
  description = "Enables HTTPS Secure Layer"
  default = "true"
}

variable "status" {
  type = string
  description = "Status Contains"
  default = <<EOF
"status":"ok"
EOF
}

variable "cmes" {
  type = string
  description = "CMessage"
  default = <<EOF
Please contact Albert - Platform Team
EOF
}


