output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "cluster_id" {
  description = "Kubernetes Cluster id"
  value       = module.eks.cluster_id
}

output "ephemeral-gha-user_iam_creds_id" {
  description = "The IAM credentials ID for the ephemeral workflow IAM account"
  value       = aws_iam_access_key.ephemeral_workflow.id
}

output "ephemeral-gha-user_iam_creds_secret" {
  description = "The IAM credentials Secret for the ephemeral workflow IAM account"
  value       = aws_iam_access_key.ephemeral_workflow.secret
}

output "ephemeral-gha-user_iam_arn" {
  description = "The IAM ARN for the ephemeral workflow IAM account"
  value       = aws_iam_user.ephemeral_workflow.arn
}
