module "gke-primary-west2" {
  source = "./gke/modules/kubify-gke/"

  cluster_name = var.cluster_name
  region       = "us-west2"
  project_id   = var.project_id
}

module "gke-primary-east1" {
  source = "./gke/modules/kubify-gke/"

  cluster_name = var.cluster_name
  region       = "us-east1"
  project_id   = var.project_id
}