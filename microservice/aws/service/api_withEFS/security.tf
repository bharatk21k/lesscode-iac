# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.ecs_cluster_name}-${var.name}-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = data.aws_alb.alb.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.service_port
    to_port         = var.service_port
    security_groups = [data.aws_security_group.lb_security_group.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "mount_target" {
  name        = "${var.ecs_cluster_name}-${var.name}-target"
  description = "Allow traffic from EFS to ECS"
  vpc_id      = data.aws_vpc.vpc.id
  tags = {
    Name    = "${var.ecs_cluster_name}-${var.service_name}-efs"
  }
}

resource "aws_security_group" "mount_target_client" {
  name        = "${var.ecs_cluster_name}-${var.name}-client"
  description = "Allow traffic out to NFS for ${var.ecs_cluster_name}-${var.name}-mnt."
  vpc_id      = data.aws_vpc.vpc.id
  depends_on = [aws_efs_mount_target.efs]
  tags = {
    Name    = "${var.ecs_cluster_name}-${var.service_name}-efs"
  }
}

resource "aws_security_group_rule" "nfs_egress" {
  description              = "Allow NFS traffic out from EC2 to mount target"
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.mount_target_client.id
  source_security_group_id = aws_security_group.mount_target.id
}

resource "aws_security_group_rule" "nfs_ingress" {
  description              = "Allow NFS traffic into mount target from EC2"
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.mount_target.id
  source_security_group_id = aws_security_group.mount_target_client.id
}

resource "aws_security_group" "efs-ec2" {
  name        = "${var.ecs_cluster_name}-${var.service_name}-ec2"
  description = "Allow ssh inbound traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.efs.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy01",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.efs.arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}

