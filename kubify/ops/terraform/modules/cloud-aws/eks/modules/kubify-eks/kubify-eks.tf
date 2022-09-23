provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      kubify = local.name
      env    = local.name
    }
  }
}
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}
locals {
  name   = var.cluster_name
  region = var.aws_region

  tags = {
    terraform_config_file = "kubify/ops/terraform/modules/cloud-aws/eks/modules/kubify-eks/kubify-eks.tf"

  }
}
module "eks" {
  source = "../aws-eks"

  cluster_enabled_log_types = ["api", "authenticator", "audit", "scheduler", "controllerManager"]
  create_iam_role           = true

  iam_role_additional_policies = var.iam_role_additional_policies
  # iam_role_additional_policies = [var.iam_role_additional_policies]

  cluster_name                    = local.name
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }
  create_kms_key = true
  cluster_encryption_config = [{
    resources = ["secrets"]
  }]
  kms_key_deletion_window_in_days = 7
  enable_kms_key_rotation         = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }
  node_security_group_ntp_ipv4_cidr_block = ["169.254.169.123/32"]
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  eks_managed_node_group_defaults = {
    ami_type       = "BOTTLEROCKET_ARM_64"
    instance_types = ["a1.medium"]

    attach_cluster_primary_security_group = true
    # vpc_security_group_ids                = [aws_security_group.additional.id]
  }

  eks_managed_node_groups = {
    cpu-atom = {
      min_size     = 2
      max_size     = 20
      desired_size = 2
      ami_type     = "BOTTLEROCKET_ARM_64"

      instance_types = ["a1.medium"]
      capacity_type  = "SPOT"
      labels = {
        kubify = local.name
        env    = local.name
      }

      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      }
    }
    cpu-intel = {
      min_size     = 0
      max_size     = 20
      desired_size = 0
      ami_type     = "BOTTLEROCKET_x86_64"

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      labels = {
        kubify = local.name
        env    = local.name
      }

      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      }
    }
    gpu-cuda = {
      min_size     = 0
      max_size     = 2
      desired_size = 0
      ami_type     = "AL2_x86_64_GPU"

      instance_types = ["g3s.xlarge"]
      capacity_type  = "SPOT"
      labels = {
        kubify = local.name
        env    = local.name
        gpu    = "spot"
      }

      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }

  # Fargate Profile(s)
  fargate_profiles = {
    default = {
      name = "fargate"
      selectors = [
        # {
        #   namespace = "kube-system"
        #   labels = {
        #     k8s-app = "kube-dns"
        #   }
        # },
        # {
        #   namespace = "default"
        # },
        {
          namespace = "fargate"
        }
      ]

      tags = {
        serverless = "fargate"
      }

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
  }
  manage_aws_auth_configmap = true
  # aws_auth_node_iam_role_arns_non_windows = [
  # ]
  # aws_auth_fargate_profile_pod_execution_role_arns = [
  # ]
  # aws_auth_roles = [
  #   {
  #     rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/role1"
  #     username = "role1"
  #     groups   = ["system:masters"]
  #   },
  # ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      username = "iam-root"
      groups   = ["system:masters"]
    },
    # {
    #   userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/user2"
    #   username = "user2"
    #   groups   = ["system:masters"]
    # },
  ]
  # aws_auth_accounts = [
  #   data.aws_caller_identity.current.account_id
  # ]
  tags = local.tags
}

################################################################################
# Supporting resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = "10.15.0.0/16"

  azs             = ["${local.region}b", "${local.region}c"]
  private_subnets = ["10.15.1.0/24", "10.15.2.0/24"]
  # public_subnets  = ["10.15.4.0/24", "10.15.5.0/24"]
  intra_subnets   = ["10.15.7.0/28", "10.15.7.16/28"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  # public_subnet_tags = {
  #   "kubernetes.io/cluster/${local.name}" = "shared"
  #   "kubernetes.io/role/elb"              = 1
  # }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
  }

  tags = local.tags
}
