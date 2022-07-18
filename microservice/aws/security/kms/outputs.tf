output "primary" {
  value = aws_kms_key.primary.arn
}

output "replica1" {
  value = aws_kms_replica_key.replica1.arn
}

output "replica2" {
  value = aws_kms_replica_key.replica2.arn
}