


module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = ">= 4.0.1, < 5.0.0"

  project_id   = module.enabled_google_apis.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = var.subnet_name
      subnet_ip             = var.subnet_ip
      subnet_region         = var.region
      subnet_private_access = true
      description           = "This subnet is managed by Terraform"
    }
  ]
  secondary_ranges = {
    (var.subnet_name) = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}


module "cloud-nat" {
  source        = "terraform-google-modules/cloud-nat/google"
  version       = "~> 1.2"
  project_id    = module.enabled_google_apis.project_id
  region        = var.region
  router        = "safer-router"
  network       = module.vpc.network_self_link
  create_router = true
}
