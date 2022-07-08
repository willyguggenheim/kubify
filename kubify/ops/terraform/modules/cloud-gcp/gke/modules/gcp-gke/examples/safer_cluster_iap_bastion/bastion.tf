

locals {
  bastion_name = format("%s-bastion", var.cluster_name)
  bastion_zone = format("%s-a", var.region)
}

data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  EOF
}

module "bastion" {
  source  = "terraform-google-modules/bastion-host/google"
  version = "~> 4.1"

  network        = module.vpc.network_self_link
  subnet         = module.vpc.subnets_self_links[0]
  project        = module.enabled_google_apis.project_id
  host_project   = module.enabled_google_apis.project_id
  name           = local.bastion_name
  zone           = local.bastion_zone
  image_project  = "debian-cloud"
  image_family   = "debian-9"
  machine_type   = "g1-small"
  startup_script = data.template_file.startup_script.rendered
  members        = var.bastion_members
  shielded_vm    = "false"
}
