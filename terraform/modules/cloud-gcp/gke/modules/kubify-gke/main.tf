data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gcp-network" {
  source  = "terraform-google-modules/network/google"
  version = ">= 4.0.1, < 5.0.0"

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

# TODO: spot
module "gke" {
  source                            = "../gcp-gke/"
  project_id                        = var.project_id
  name                              = var.cluster_name
  regional                          = true
  region                            = var.region
  network                           = module.gcp-network.network_name
  subnetwork                        = module.gcp-network.subnets_names[0]
  ip_range_pods                     = var.ip_range_pods_name
  ip_range_services                 = var.ip_range_services_name
  create_service_account            = true
  network_policy                    = true
  disable_legacy_metadata_endpoints = true
  cluster_resource_labels = {
    kubify  = "true",
    cluster = var.cluster_name
  }
}
