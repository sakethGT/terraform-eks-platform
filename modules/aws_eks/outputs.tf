output "cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA role creation"
  value       = module.eks.oidc_provider_arn
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}
