

# Create the membership
resource "google_gke_hub_membership" "primary" {
  count    = var.enable_fleet_registration ? 1 : 0
  provider = google-beta

  project       = local.hub_project_id
  membership_id = local.gke_hub_membership_name

  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${data.google_container_cluster.primary.id}"
    }
  }
  authority {
    issuer = "https://container.googleapis.com/v1/${data.google_container_cluster.primary.id}"
  }
}
