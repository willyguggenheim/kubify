module "aws" {
  source       = "./modules/cloud-aws/"
  cluster_name = var.cluster_name
}

module "gcp" {
  source       = "./modules/cloud-gcp/"
  cluster_name = var.cluster_name
  project_id   = var.gcp_project_id
}

module "az" {
  source       = "./modules/cloud-az/"
  cluster_name = var.cluster_name
}