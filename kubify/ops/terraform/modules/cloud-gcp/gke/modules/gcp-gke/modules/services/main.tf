

module "services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.3"

  project_id                  = var.project_id
  enable_apis                 = var.enable_apis
  disable_services_on_destroy = var.disable_services_on_destroy
  disable_dependent_services  = var.disable_dependent_services

  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com"
  ]
}
