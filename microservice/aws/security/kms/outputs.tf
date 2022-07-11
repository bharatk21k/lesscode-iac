output "primary" {
  value = aws_kms_external_key.primary[0].arn
}

output "replica1" {
  value = aws_kms_replica_external_key.replica1.arn
}

output "replica2" {
  value = aws_kms_replica_external_key.replica2.arn
}