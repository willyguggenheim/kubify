

resource "google_gke_hub_feature" "acm" {
  count    = var.enable_fleet_feature ? 1 : 0
  provider = google-beta

  name     = "configmanagement"
  project  = var.project_id
  location = "global"
}

resource "google_gke_hub_feature_membership" "main" {
  provider = google-beta
  depends_on = [
    google_gke_hub_feature.acm
  ]

  location = "global"
  feature  = "configmanagement"

  membership = module.registration.cluster_membership_id
  project    = var.project_id

  configmanagement {
    version = "1.11.0"

    config_sync {
      source_format = var.source_format != "" ? var.source_format : null

      git {
        sync_repo   = var.sync_repo
        policy_dir  = var.policy_dir != "" ? var.policy_dir : null
        sync_branch = var.sync_branch != "" ? var.sync_branch : null
        sync_rev    = var.sync_revision != "" ? var.sync_revision : null
        secret_type = var.secret_type
      }
    }

    dynamic "policy_controller" {
      for_each = var.enable_policy_controller ? [{ enabled = true }] : []

      content {
        enabled                    = true
        template_library_installed = var.install_template_library
        log_denies_enabled         = var.enable_log_denies
      }
    }

    dynamic "hierarchy_controller" {
      for_each = var.hierarchy_controller == null ? [] : [var.hierarchy_controller]

      content {
        enabled                            = true
        enable_hierarchical_resource_quota = each.value.enable_hierarchical_resource_quota
        enable_pod_tree_labels             = each.value.enable_pod_tree_labels
      }
    }
  }
}
