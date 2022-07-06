module "aws" {
  source       = "./modules/cloud-aws/"
  cluster_name = var.cluster_name
}

module "gcp" {
  source       = "./modules/cloud-gcp/"
  cluster_name = var.cluster_name
  project_id   = var.gcp_project_id
}

module "azure" {
  source       = "./modules/cloud-azure/"
  cluster_name = var.cluster_name
}