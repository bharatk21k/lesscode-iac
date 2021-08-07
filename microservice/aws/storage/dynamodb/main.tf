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

   
  attribute {
    count = length(var.gsis)  
    name = "${var.gsis[count.index].hash_key}"
    type = "S"
  }
  attribute {
    count = length(var.gsis)
    name = "${var.gsis[count.index].range_key}"
    type = "N"
  }
  global_secondary_index {
    count = length(var.gsis)
    name            = "${var.gsis[count.index].name}"
    hash_key        = "${var.gsis[count.index].hash_key}"
    range_key       = "${var.gsis[count.index].range_key}"
    projection_type = "${var.gsis[count.index].projection_type}"
  }

  tags = {
    Name        = "dynamodb-table"
    Environment = "${var.ecs_cluster_name}"
  }
}
