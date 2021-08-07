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
    name    = "expiresAt"
    enabled = true
  }

  for_each = { for gsi in var.gsis : gsi.name => gsi }
  attribute {
    name = each.value.hash_key
    type = "S"
  }
  attribute {
    name = each.value.range_key
    type = "S"
  }
  global_secondary_index {
    name            = each.value.name
    hash_key        = each.value.hash_key
    range_key       = each.value.range_key
    projection_type = each.value.projection_type
  }

  tags = {
    Name        = "dynamodb-table"
    Environment = "${var.ecs_cluster_name}"
  }
}
