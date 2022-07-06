

resource "google_gke_hub_membership" "membership" {
  count         = var.enable_fleet_registration ? 1 : 0
  provider      = google-beta
  project       = local.fleet_id
  membership_id = "${data.google_container_cluster.asm.name}-membership"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${data.google_container_cluster.asm.id}"
    }
  }
}

resource "google_gke_hub_feature" "mesh" {
  count    = var.enable_mesh_feature ? 1 : 0
  name     = "servicemesh"
  project  = local.fleet_id
  location = "global"
  provider = google-beta
}
