resource "aws_sns_topic" "sns" {
  name              = var.name
  
  tags = {
    env = var.env
  }
}