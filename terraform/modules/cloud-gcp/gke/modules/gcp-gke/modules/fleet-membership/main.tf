

locals {
  hub_project_id          = var.hub_project_id == "" ? var.project_id : var.hub_project_id
  gke_hub_membership_name = var.membership_name != "" ? var.membership_name : "${var.project_id}-${var.location}-${var.cluster_name}"
}

# Retrieve GKE cluster info
data "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.location
  project  = var.project_id
}

# Give the service agent permissions on hub project
resource "google_project_iam_member" "hub_service_agent_gke" {
  count   = var.hub_project_id == "" ? 0 : 1
  project = var.hub_project_id
  role    = "roles/gkehub.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.sa_gkehub[0].email}"
}

resource "google_project_iam_member" "hub_service_agent_hub" {
  count   = var.hub_project_id == "" ? 0 : 1
  project = local.hub_project_id
  role    = "roles/gkehub.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.sa_gkehub[0].email}"
}

resource "google_project_service_identity" "sa_gkehub" {
  count    = var.hub_project_id == "" ? 0 : 1
  provider = google-beta
  project  = local.hub_project_id
  service  = "gkehub.googleapis.com"
}
