output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "timescaledb_endpoint" {
  value = module.timescaledb.endpoint
}

output "telemetry_ingestor_role_arn" {
  value = module.iam.telemetry_ingestor_role_arn
}

