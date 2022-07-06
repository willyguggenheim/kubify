

locals {
  cluster_type = "node-pool"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                            = "../../modules/beta-public-cluster/"
  project_id                        = var.project_id
  name                              = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  region                            = var.region
  zones                             = var.zones
  network                           = var.network
  subnetwork                        = var.subnetwork
  ip_range_pods                     = var.ip_range_pods
  ip_range_services                 = var.ip_range_services
  create_service_account            = false
  remove_default_node_pool          = true
  disable_legacy_metadata_endpoints = true
  cluster_autoscaling               = var.cluster_autoscaling

  node_pools = [
    {
      name            = "pool-01"
      min_count       = 1
      max_count       = 2
      service_account = var.compute_engine_service_account
      auto_upgrade    = true
    },
    {
      name               = "pool-02"
      machine_type       = "a2-highgpu-1g"
      min_count          = 1
      max_count          = 2
      local_ssd_count    = 0
      disk_size_gb       = 30
      disk_type          = "pd-standard"
      accelerator_count  = 1
      accelerator_type   = "nvidia-tesla-a100"
      gpu_partition_size = "1g.5gb"
      auto_repair        = false
      service_account    = var.compute_engine_service_account
    },
    {
      name               = "pool-03"
      machine_type       = "n1-standard-2"
      node_locations     = "${var.region}-b,${var.region}-c"
      autoscaling        = false
      node_count         = 2
      disk_type          = "pd-standard"
      auto_upgrade       = true
      service_account    = var.compute_engine_service_account
      pod_range          = "test"
      sandbox_enabled    = true
      cpu_manager_policy = "static"
      cpu_cfs_quota      = true
    },
  ]

  node_pools_metadata = {
    pool-01 = {
      shutdown-script = file("${path.module}/data/shutdown-script.sh")
    }
  }

  node_pools_labels = {
    all = {
      all-pools-example = true
    }
    pool-01 = {
      pool-01-example = true
    }
  }

  node_pools_taints = {
    all = [
      {
        key    = "all-pools-example"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
    pool-01 = [
      {
        key    = "pool-01-example"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = [
      "all-node-example",
    ]
    pool-01 = [
      "pool-01-example",
    ]
  }

  node_pools_linux_node_configs_sysctls = {
    all = {
      "net.core.netdev_max_backlog" = "10000"
    }
    pool-01 = {
      "net.core.rmem_max" = "10000"
    }
    pool-03 = {
      "net.core.netdev_max_backlog" = "20000"
    }
  }
}