

module "acm" {
  source       = "../../modules/acm"
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name

  sync_repo   = "git@github.com:GoogleCloudPlatform/csp-config-management.git"
  sync_branch = "1.0.0"
  policy_dir  = "foo-corp"

  secret_type = "ssh"
}
