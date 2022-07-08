

module "gke" {
  source = "../../modules/safer-cluster"

  project_id              = module.enabled_google_apis.project_id
  name                    = var.cluster_name
  region                  = var.region
  network                 = module.vpc.network_name
  subnetwork              = module.vpc.subnets_names[0]
  ip_range_pods           = module.vpc.subnets_secondary_ranges[0].*.range_name[0]
  ip_range_services       = module.vpc.subnets_secondary_ranges[0].*.range_name[1]
  enable_private_endpoint = false
  master_authorized_networks = [{
    cidr_block   = "${module.bastion.ip_address}/32"
    display_name = "Bastion Host"
  }]
  grant_registry_access = true
  node_pools = [
    {
      name          = "safer-pool"
      min_count     = 1
      max_count     = 4
      auto_upgrade  = true
      node_metadata = "GKE_METADATA"
    }
  ]
}
