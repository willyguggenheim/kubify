

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  cluster_type           = "safer-cluster"
  network_name           = "safer-cluster-network-${random_string.suffix.result}"
  subnet_name            = "safer-cluster-subnet"
  master_auth_subnetwork = "safer-cluster-master-subnet"
  pods_range_name        = "ip-range-pods-${random_string.suffix.result}"
  svc_range_name         = "ip-range-svc-${random_string.suffix.result}"
  subnet_names           = [for subnet_self_link in module.gcp-network.subnets_self_links : split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]]
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                     = "../../modules/safer-cluster/"
  project_id                 = var.project_id
  name                       = "${local.cluster_type}-cluster-${random_string.suffix.result}"
  regional                   = true
  region                     = var.region
  network                    = module.gcp-network.network_name
  subnetwork                 = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods              = local.pods_range_name
  ip_range_services          = local.svc_range_name
  master_ipv4_cidr_block     = "172.16.0.0/28"
  add_cluster_firewall_rules = true
  firewall_inbound_ports     = ["9443", "15017"]

  master_authorized_networks = [
    {
      cidr_block   = "10.60.0.0/17"
      display_name = "VPC"
    },
  ]

  istio    = true
  cloudrun = true

  notification_config_topic = google_pubsub_topic.updates.id
}

resource "google_pubsub_topic" "updates" {
  name    = "cluster-updates-${random_string.suffix.result}"
  project = var.project_id
}
