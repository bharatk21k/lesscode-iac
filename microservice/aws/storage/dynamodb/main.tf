resource "aws_dynamodb_table" "defaults" {
  name         = var.name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  range_key    = var.range_key


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

  tags = {
    Name        = "dynamodb-table"
    Environment = "${var.ecs_cluster_name}"
  }
}
