

locals {
  cluster_ca_certificate = data.google_container_cluster.gke_cluster.master_auth != null ? data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate : ""
  private_endpoint       = try(data.google_container_cluster.gke_cluster.private_cluster_config[0].private_endpoint, "")
  default_endpoint       = data.google_container_cluster.gke_cluster.endpoint != null ? data.google_container_cluster.gke_cluster.endpoint : ""
  endpoint               = var.use_private_endpoint == true ? local.private_endpoint : local.default_endpoint
  host                   = local.endpoint != "" ? "https://${local.endpoint}" : ""
  context                = data.google_container_cluster.gke_cluster.name != null ? data.google_container_cluster.gke_cluster.name : ""
}

data "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.location
  project  = var.project_id
}

data "google_client_config" "provider" {}
