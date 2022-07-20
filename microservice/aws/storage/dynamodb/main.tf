data "aws_kms_key" "partition" {
  key_id = var.partition_name
}

resource "aws_dynamodb_table" "defaults" {
  name         = "${var.name}-${var.ecs_cluster_name}"
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  range_key    = var.range_key
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = var.hash_key
    type = "S"
  }

  attribute {
    name = var.range_key
    type = "S"
  }

  ttl {
    attribute_name    = "expiresAt"
    enabled = true
  }


  attribute {
    name = var.GS1.hash_key
    type = "S"
  }

  attribute {
    name = var.GS1.range_key
    type = "S"
  }

  attribute {
    name = var.GS2.hash_key
    type = "S"
  }

  attribute {
    name = var.GS2.range_key
    type = "S"
  }

  attribute {
    name = var.GS3.hash_key
    type = "S"
  }

  attribute {
    name = var.GS3.range_key
    type = "S"
  }

  attribute {
    name = var.GS4.hash_key
    type = "S"
  }

  attribute {
    name = var.GS4.range_key
    type = "S"
  }

  attribute {
    name = var.GS5.hash_key
    type = "S"
  }

  attribute {
    name = var.GS5.range_key
    type = "S"
  }


  global_secondary_index {
    name            = var.GS1.name
    hash_key        = var.GS1.hash_key
    range_key       = var.GS1.range_key
    projection_type = var.GS1.projection_type
  }

  global_secondary_index {
    name            = var.GS2.name
    hash_key        = var.GS2.hash_key
    range_key       = var.GS2.range_key
    projection_type = var.GS2.projection_type
  }

  global_secondary_index {
    name            = var.GS3.name
    hash_key        = var.GS3.hash_key
    range_key       = var.GS3.range_key
    projection_type = var.GS3.projection_type
  }

  global_secondary_index {
    name            = var.GS4.name
    hash_key        = var.GS4.hash_key
    range_key       = var.GS4.range_key
    projection_type = var.GS4.projection_type
  }

  global_secondary_index {
    name            = var.GS5.name
    hash_key        = var.GS5.hash_key
    range_key       = var.GS5.range_key
    projection_type = var.GS5.projection_type
  }

  tags = {
    Name        = "${var.ecs_cluster_name}"
  }

  server_side_encryption{
    enabled = true
    kms_key_arn = data.aws_kms_alias.partition.arn
  }
}
