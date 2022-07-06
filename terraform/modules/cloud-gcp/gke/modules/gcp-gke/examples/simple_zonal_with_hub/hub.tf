

module "hub" {
  source       = "../../modules/fleet-membership"
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name

  depends_on = [module.gke]
}
