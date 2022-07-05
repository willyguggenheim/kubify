################################################################################
################################################################################
################################################################################

################################################################################
##### PRIMARY OUTPUTS ########################################################## 
################################################################################

################################################################################
# Cluster
################################################################################

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks-primary-us-west-2.cluster_arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks-primary-us-west-2.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks-primary-us-west-2.cluster_endpoint
}

output "cluster_id" {
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready"
  value       = module.eks-primary-us-west-2.cluster_id
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks-primary-us-west-2.cluster_oidc_issuer_url
}

output "cluster_platform_version" {
  description = "Platform version for the cluster"
  value       = module.eks-primary-us-west-2.cluster_platform_version
}

output "cluster_status" {
  description = "Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`"
  value       = module.eks-primary-us-west-2.cluster_status
}

output "cluster_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = module.eks-primary-us-west-2.cluster_security_group_id
}

################################################################################
# KMS Key
################################################################################

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = module.eks-primary-us-west-2.kms_key_arn
}

output "kms_key_id" {
  description = "The globally unique identifier for the key"
  value       = module.eks-primary-us-west-2.kms_key_id
}

output "kms_key_policy" {
  description = "The IAM resource policy set on the key"
  value       = module.eks-primary-us-west-2.kms_key_policy
}

################################################################################
# Security Group
################################################################################

output "cluster_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the cluster security group"
  value       = module.eks-primary-us-west-2.cluster_security_group_arn
}

################################################################################
# IRSA
################################################################################

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = module.eks-primary-us-west-2.oidc_provider
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`"
  value       = module.eks-primary-us-west-2.oidc_provider_arn
}

################################################################################
# IAM Role
################################################################################

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = module.eks-primary-us-west-2.cluster_iam_role_name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = module.eks-primary-us-west-2.cluster_iam_role_arn
}

output "cluster_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.eks-primary-us-west-2.cluster_iam_role_unique_id
}

################################################################################
# EKS Addons
################################################################################

output "cluster_addons" {
  description = "Map of attribute maps for all EKS cluster addons enabled"
  value       = module.eks-primary-us-west-2.cluster_addons
}

################################################################################
# EKS Identity Provider
################################################################################

output "cluster_identity_providers" {
  description = "Map of attribute maps for all EKS identity providers enabled"
  value       = module.eks-primary-us-west-2.cluster_identity_providers
}

################################################################################
# CloudWatch Log Group
################################################################################

output "cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created"
  value       = module.eks-primary-us-west-2.cloudwatch_log_group_name
}

output "cloudwatch_log_group_arn" {
  description = "Arn of cloudwatch log group created"
  value       = module.eks-primary-us-west-2.cloudwatch_log_group_arn
}

################################################################################
# Fargate Profile
################################################################################

output "fargate_profiles" {
  description = "Map of attribute maps for all EKS Fargate Profiles created"
  value       = module.eks-primary-us-west-2.fargate_profiles
}

################################################################################
# EKS Managed Node Group
################################################################################

output "eks_managed_node_groups" {
  description = "Map of attribute maps for all EKS managed node groups created"
  value       = module.eks-primary-us-west-2.eks_managed_node_groups
}

output "eks_managed_node_groups_autoscaling_group_names" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = module.eks-primary-us-west-2.eks_managed_node_groups_autoscaling_group_names
}

################################################################################
# Self Managed Node Group
################################################################################

output "self_managed_node_groups" {
  description = "Map of attribute maps for all self managed node groups created"
  value       = module.eks-primary-us-west-2.self_managed_node_groups
}

output "self_managed_node_groups_autoscaling_group_names" {
  description = "List of the autoscaling group names created by self-managed node groups"
  value       = module.eks-primary-us-west-2.self_managed_node_groups_autoscaling_group_names
}

################################################################################
# Additional
################################################################################

output "aws_auth_configmap_yaml" {
  description = "Formatted yaml output for base aws-auth configmap containing roles used in cluster node groups/fargate profiles"
  value       = module.eks-primary-us-west-2.aws_auth_configmap_yaml
}

################################################################################
################################################################################
################################################################################

################################################################################
##### DR OUTPUTS ###############################################################
################################################################################

output "dr_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks-dr-us-east-1.cluster_arn
}

output "dr_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks-dr-us-east-1.cluster_certificate_authority_data
}

output "dr_cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks-dr-us-east-1.cluster_endpoint
}

output "dr_cluster_id" {
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready"
  value       = module.eks-dr-us-east-1.cluster_id
}

output "dr_cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks-dr-us-east-1.cluster_oidc_issuer_url
}

output "dr_cluster_platform_version" {
  description = "Platform version for the cluster"
  value       = module.eks-dr-us-east-1.cluster_platform_version
}

output "dr_cluster_status" {
  description = "Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`"
  value       = module.eks-dr-us-east-1.cluster_status
}

output "dr_cluster_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = module.eks-dr-us-east-1.cluster_security_group_id
}

################################################################################
# KMS Key
################################################################################

output "dr_kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = module.eks-dr-us-east-1.kms_key_arn
}

output "dr_kms_key_id" {
  description = "The globally unique identifier for the key"
  value       = module.eks-dr-us-east-1.kms_key_id
}

output "dr_kms_key_policy" {
  description = "The IAM resource policy set on the key"
  value       = module.eks-dr-us-east-1.kms_key_policy
}

################################################################################
# Security Group
################################################################################

output "dr_cluster_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the cluster security group"
  value       = module.eks-dr-us-east-1.cluster_security_group_arn
}

################################################################################
# IRSA
################################################################################

output "dr_oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = module.eks-dr-us-east-1.oidc_provider
}

output "dr_oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`"
  value       = module.eks-dr-us-east-1.oidc_provider_arn
}

################################################################################
# IAM Role
################################################################################

output "dr_cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = module.eks-dr-us-east-1.cluster_iam_role_name
}

output "dr_cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = module.eks-dr-us-east-1.cluster_iam_role_arn
}

output "dr_cluster_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.eks-dr-us-east-1.cluster_iam_role_unique_id
}

################################################################################
# EKS Addons
################################################################################

output "dr_cluster_addons" {
  description = "Map of attribute maps for all EKS cluster addons enabled"
  value       = module.eks-dr-us-east-1.cluster_addons
}

################################################################################
# EKS Identity Provider
################################################################################

output "dr_cluster_identity_providers" {
  description = "Map of attribute maps for all EKS identity providers enabled"
  value       = module.eks-dr-us-east-1.cluster_identity_providers
}

################################################################################
# CloudWatch Log Group
################################################################################

output "dr_cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created"
  value       = module.eks-dr-us-east-1.cloudwatch_log_group_name
}

output "dr_cloudwatch_log_group_arn" {
  description = "Arn of cloudwatch log group created"
  value       = module.eks-dr-us-east-1.cloudwatch_log_group_arn
}

################################################################################
# Fargate Profile
################################################################################

output "dr_fargate_profiles" {
  description = "Map of attribute maps for all EKS Fargate Profiles created"
  value       = module.eks-dr-us-east-1.fargate_profiles
}

################################################################################
# EKS Managed Node Group
################################################################################

output "dr_eks_managed_node_groups" {
  description = "Map of attribute maps for all EKS managed node groups created"
  value       = module.eks-dr-us-east-1.eks_managed_node_groups
}

output "dr_eks_managed_node_groups_autoscaling_group_names" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = module.eks-dr-us-east-1.eks_managed_node_groups_autoscaling_group_names
}

################################################################################
# Self Managed Node Group
################################################################################

output "dr_self_managed_node_groups" {
  description = "Map of attribute maps for all self managed node groups created"
  value       = module.eks-dr-us-east-1.self_managed_node_groups
}

output "dr_self_managed_node_groups_autoscaling_group_names" {
  description = "List of the autoscaling group names created by self-managed node groups"
  value       = module.eks-dr-us-east-1.self_managed_node_groups_autoscaling_group_names
}

################################################################################
# Additional
################################################################################

output "dr_aws_auth_configmap_yaml" {
  description = "Formatted yaml output for base aws-auth configmap containing roles used in cluster node groups/fargate profiles"
  value       = module.eks-dr-us-east-1.aws_auth_configmap_yaml
}