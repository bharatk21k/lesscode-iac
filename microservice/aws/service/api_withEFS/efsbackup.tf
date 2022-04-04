locals {
  create_backup_resources = var.enable_backups
  create_backup_kms_key   = local.create_backup_resources && var.backup_kms_key_id == null
  kms_key_arn             = local.create_backup_kms_key ? aws_kms_key.backup[0].arn : var.backup_kms_key_id
}

data "aws_iam_policy_document" "assume_backup" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "backup" {

  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:Backup",
      "elasticfilesystem:Restore",
      "elasticfilesystem:CreateFilesystem",
      "elasticfilesystem:DescribeFilesystems",
      "elasticfilesystem:DeleteFilesystem",
      "elasticfilesystem:DescribeTags"
    ]
    resources = [
      try(aws_efs_file_system.efs.arn, "arn:aws:elasticfilesystem:*:*:file-system/*")
    ]
  }

  statement {
    actions   = ["tag:GetResources"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "backup:DescribeBackupVault",
      "backup:CopyIntoBackupVault"
    ]
    resources = [
      try(aws_backup_vault.backup[0].arn, "arn:aws:backup:*:*:backup-vault:*")
    ]
  }
}

resource "aws_iam_role" "backup" {
  count = local.create_backup_resources ? 1 : 0
  name_prefix = substr("${var.name}-backup", 0, 32)
  assume_role_policy   = data.aws_iam_policy_document.assume_backup.json
  permissions_boundary = var.backup_role_permissions_boundary
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = var.ecs_cluster_name
    Environment = var.env
    CreatedTime = timestamp()
 }
}

resource "aws_iam_role_policy" "backup" {
  count = local.create_backup_resources ? 1 : 0
  name_prefix = "${var.name}-backup"
  role   = aws_iam_role.backup[0].id
  policy = data.aws_iam_policy_document.backup.json
}

resource "aws_kms_key" "backup" {
  count = local.create_backup_kms_key ? 1 : 0
  enable_key_rotation = true
  tags = {
    Name = var.ecs_cluster_name
    Environment = var.env
    CreatedTime = timestamp()
 }
}

resource "aws_backup_vault" "backup" {
  count = local.create_backup_resources ? 1 : 0
  name        = "${var.name}-vault"
  kms_key_arn = local.kms_key_arn
  tags = {
    Name = var.ecs_cluster_name
    Environment = var.env
    CreatedTime = timestamp()
 }
}

resource "aws_backup_plan" "backup" {
  count = local.create_backup_resources ? 1 : 0
  name = "${var.name}-plan"
  rule {
    rule_name         = "${var.name}-cron-rule"
    target_vault_name = aws_backup_vault.backup[0].name
    schedule          = var.backup_schedule
  }
  tags = {
    Name = var.ecs_cluster_name
    Environment = var.env
    CreatedTime = timestamp()
 }
}

resource "aws_backup_selection" "backup" {
  count = local.create_backup_resources ? 1 : 0
  name         = "${var.name}-selection"
  iam_role_arn = aws_iam_role.backup[0].arn
  plan_id      = aws_backup_plan.backup[0].id
  resources = [
    aws_efs_file_system.efs.arn
  ]
}

resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.efs.id
  backup_policy {
    status = "ENABLED"
  }
}

