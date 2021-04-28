variable "atlantis_image" {
  default = "exositebot/atlantis-terragrunt:v0.8.3-v0.19.21_8"
}

variable "aws_region" {
  default = "us-west-2"
}

variable "atlantis_github_user_token" {}

variable "infrastructure_deploy_key_ssm_parameter_name" {
  default = "/atlantis/ssh_private_key"
}

variable "name" {
  default = "bootstrap"
}

variable "module_repositories" {
  type = "list"

  default = [
    "kubify"
  ]
}

variable "github_user" {
  default = "kubifyuild"
}

variable "github_organization_name" {
  default = "kubify"
}

variable "route53_zone_name" {
  default = "kubify.dev"
}

variable "atlantis_allowed_repo_names" {
  default = [
    "*"
  ]
}

variable "atlantis_repo_whitelist" {
  default = [
    "github.com/willyguggenheim/kubify"
  ]
}

variable "cidr" {
  default = "172.16.0.0/16"
}

variable "azs" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "private_subnets" {
  default = ["172.16.1.0/24", "172.16.2.0/24"]
}

variable "public_subnets" {
  default = ["172.16.11.0/24", "172.16.12.0/24"]
}
