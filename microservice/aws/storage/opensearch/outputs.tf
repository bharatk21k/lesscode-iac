#######################################################
# Opensearch
#######################################################

output "elasticsearch_domain_arn" {
  value = aws_elasticsearch_domain.aos.arn
}

output "elasticsearch_domain_id" {
  value = aws_elasticsearch_domain.aos.domain_id
}

output "elasticsearch_domain_name" {
  value = aws_elasticsearch_domain.aos.domain_name
}

output "elasticsearch_domain_endpoint" {
  value = aws_elasticsearch_domain.aos.endpoint
}

output "elasticsearch_domain_kibana_endpoint" {
  value = aws_elasticsearch_domain.aos.kibana_endpoint
}

output "elasticsearch_security_group_id" {
  value = aws_security_group.opensearch.id
}

output "vpc" {
  value = data.aws_vpc.vpc.id
}

output "private-subs" {
    value = [data.aws_subnet_ids.private.ids]
}

output "ecs_cluster_arn" {
  value = data.aws_ecs_cluster.ecs_cluster_name.arn
}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

