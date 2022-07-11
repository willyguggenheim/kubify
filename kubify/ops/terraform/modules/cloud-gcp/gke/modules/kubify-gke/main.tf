data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gcp-network" {
  source = "terraform-google-modules/network/google"
  # version = ">= 4.0.1, < 5.0.0"

  project_id   = var.project_id
  network_name = var.network

  subnets = [
    {
      subnet_name      = var.subnetwork
      subnet_ip        = "10.200.0.0/20"
      subnet_region    = var.region
      subnet_flow_logs = true
    },
  ]

  secondary_ranges = {
    (var.subnetwork) = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "192.168.200.0/20"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "192.168.220.0/20"
      },
    ]
  }
}

module "gke" {
  source            = "../gcp-gke/"
  project_id        = var.project_id
  name              = var.cluster_name
  region            = var.region
  regional          = true
  network           = module.gcp-network.network_name
  subnetwork        = module.gcp-network.subnets_names[0]
  ip_range_pods     = module.gcp-network.subnets_secondary_ranges[0].*.range_name[0]
  ip_range_services = module.gcp-network.subnets_secondary_ranges[0].*.range_name[1]
  # enable_private_endpoint = true
  # enable_private_nodes    = true
  # master_ipv4_cidr_block            = "172.16.0.16/28"
  network_policy                    = true
  horizontal_pod_autoscaling        = true
  service_account                   = "create"
  remove_default_node_pool          = true
  disable_legacy_metadata_endpoints = true
  # cluster_resource_labels           = {
  #   "kubernetes.io/cluster/" + var.cluster_name = "owned", 
  #   "kubify" = "true"
  # }

  master_authorized_networks = [
    {
      cidr_block   = module.gcp-network.subnets_ips[0]
      display_name = "VPC"
    },
  ]

  # https://cloud.google.com/products/calculator
  node_pools = [
    {
      name               = "my-node-pool"
      machine_type       = "n1-standard-1"
      min_count          = 1
      max_count          = 10
      disk_size_gb       = 50
      disk_type          = "pd-ssd"
      auto_repair        = true
      auto_upgrade       = false
      preemptible        = true
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
    ]

    my-node-pool = [
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
    ]
  }

  node_pools_labels = {

    all = {

    }
    my-node-pool = {

    }
  }

  node_pools_metadata = {
    all = {}

    my-node-pool = {}

  }

  node_pools_tags = {
    all = []

    my-node-pool = []

  }
}



# project_id                        = var.project_id
# name                              = var.cluster_name
# regional                          = true
# region                            = var.region
# network                           = module.gcp-network.network_name
# subnetwork                        = module.gcp-network.subnets_names[0]
# ip_range_pods                     = var.ip_range_pods_name
# ip_range_services                 = var.ip_range_services_name
# create_service_account            = true
# network_policy                    = true
# disable_legacy_metadata_endpoints = true
