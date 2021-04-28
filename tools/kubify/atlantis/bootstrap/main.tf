terraform {
  backend "s3" {
    bucket  = "kubify-com-state-atlantis"
    key     = "global/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

provider "github" {
  token        = "${var.atlantis_github_user_token}"
  organization = "${var.github_organization_name}"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "tls_private_key" "infrastructure_modules_deploy_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "github_repository_deploy_key" "infrastructure_modules_deploy_key" {
  count      = "${length(var.module_repositories)}"
  title      = "Infrastructure Modules Deploy Key"
  repository = "${element(var.module_repositories, count.index)}"
  key        = "${tls_private_key.infrastructure_modules_deploy_key.public_key_openssh}"
  read_only  = "true"
}

resource "aws_ssm_parameter" "infrastructure_modules_deploy_private_key" {
  name  = "${var.infrastructure_deploy_key_ssm_parameter_name}"
  type  = "SecureString"
  value = "${tls_private_key.infrastructure_modules_deploy_key.private_key_pem}"
}

data "aws_iam_policy_document" "infrastructure_access_secrets" {
  statement {
    effect = "Allow"

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${var.infrastructure_deploy_key_ssm_parameter_name}",
    ]

    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
    ]
  }
}

resource "aws_iam_policy" "infrastructure_access_secrets" {
  name        = "ECSTaskInfrastructureSecretsPolicy"
  path        = "/"
  description = "Policy to access bootstrap infrastructure secrets"
  policy      = "${data.aws_iam_policy_document.infrastructure_access_secrets.json}"
}

module "atlantis" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-atlantis.git?ref=v2.24.0"

  cidr = "${var.cidr}"
  azs  = "${var.azs}"

  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  route53_zone_name = "${var.route53_zone_name}"

  ecs_service_assign_public_ip = true

  atlantis_image              = "${var.atlantis_image}"
  atlantis_allowed_repo_names = "${var.atlantis_allowed_repo_names}"
  atlantis_repo_whitelist     = "${var.atlantis_repo_whitelist}"
  allow_repo_config           = "true"
  atlantis_github_user        = "${var.github_user}"
  atlantis_github_user_token  = "${var.atlantis_github_user_token}"

  ssh_private_key_ssm_parameter_name = "${var.infrastructure_deploy_key_ssm_parameter_name}"

  tags = {
    Name = "atlantis"
  }

  policies_count = 3
  policies_arn = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "${aws_iam_policy.infrastructure_access_secrets.arn}"
  ]
}
