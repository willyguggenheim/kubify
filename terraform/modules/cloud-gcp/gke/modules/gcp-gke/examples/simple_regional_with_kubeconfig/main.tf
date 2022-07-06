

locals {
  cluster_type = "simple-regional"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                 = "../../"
  project_id             = var.project_id
  name                   = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional               = true
  region                 = var.region
  network                = var.network
  subnetwork             = var.subnetwork
  ip_range_pods          = var.ip_range_pods
  ip_range_services      = var.ip_range_services
  create_service_account = false
  service_account        = var.compute_engine_service_account
  skip_provisioners      = var.skip_provisioners
}

module "gke_auth" {
  source = "../../modules/auth"

  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
}

