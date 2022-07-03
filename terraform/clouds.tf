module "aws-eks" {
  source       = "./modules/cloud-aws/eks"
  cluster_name = var.cluster_name
}

module "gcp-gke" {
  source       = "./modules/cloud-gcp/gke"
  cluster_name = var.cluster_name
  project_id   = var.gcp_project_id
  # providers = {
  #   google = "google"
  # }
}

module "az-aks" {
  source       = "./modules/cloud-az/aks"
  cluster_name = var.cluster_name
}