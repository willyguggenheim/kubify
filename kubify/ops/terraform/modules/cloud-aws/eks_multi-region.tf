module "eks-primary-us-west-2" {
  source = "./eks/modules/kubify-eks/"

  cluster_name = var.cluster_name
  iam_role_additional_policies = [
    "arn:aws:iam::aws:policy/AutoScalingServiceRolePolicy",
    # put additional permissions here by custom policy and calling arn here
  ]
  aws_region = "us-west-2"
}

module "eks-dr-us-east-1" {
  source = "./eks/modules/kubify-eks/"

  cluster_name = var.cluster_name
  iam_role_additional_policies = [
    "arn:aws:iam::aws:policy/AutoScalingServiceRolePolicy",
    # put additional permissions here by custom policy and calling arn here
  ]
  aws_region = "us-east-1"
}