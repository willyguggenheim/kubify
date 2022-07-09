locals {
  iam_role_additional_policies = [
    try(aws_iam_policy.helm_cluster_autoscaler.arn, "arn:aws:iam::aws:policy/AutoScalingReadOnlyAccess"), # leave the autoscaler policy first
    # "arn:aws:iam::aws:policy/AutoScalingReadOnlyAccess", # example
    # and then any other policies you want to add to the IAM role
  ]
}

module "eks-primary-us-west-2" {
  source = "./eks/modules/kubify-eks/"

  cluster_name                 = var.cluster_name
  iam_role_additional_policies = local.iam_role_additional_policies
  aws_region                   = "us-west-2"
}

module "eks-dr-us-east-1" {
  source = "./eks/modules/kubify-eks/"

  cluster_name                 = var.cluster_name
  iam_role_additional_policies = local.iam_role_additional_policies
  aws_region                   = "us-east-1"
}