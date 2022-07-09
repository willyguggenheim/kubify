# Tips


# EKS

To reset your aws_auth (force fetch token), simply: `terraform state rm module.aws.module.eks-primary-us-west-2.module.eks.kubernetes_config_map_v1_data.aws_auth`