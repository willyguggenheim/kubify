module "aws" {
  source       = "./modules/cloud-aws"
  cluster_name = var.cluster_name
}

module "gcp" {
  source       = "./modules/cloud-gcp"
  cluster_name = var.cluster_name
}

module "az" {
  source       = "./modules/cloud-az"
  cluster_name = var.cluster_name
}