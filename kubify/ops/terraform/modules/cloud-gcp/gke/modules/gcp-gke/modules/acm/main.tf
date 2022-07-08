

locals {
  private_key            = var.create_ssh_key && var.ssh_auth_key == null ? tls_private_key.k8sop_creds[0].private_key_pem : var.ssh_auth_key
  k8sop_creds_secret_key = var.secret_type == "cookiefile" ? "cookie_file" : var.secret_type
}

module "registration" {
  source = "../fleet-membership"

  cluster_name              = var.cluster_name
  project_id                = var.project_id
  location                  = var.location
  enable_fleet_registration = var.enable_fleet_registration
  membership_name           = var.cluster_membership_id
}
