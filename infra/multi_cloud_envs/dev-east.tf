module "gcp" {
  source          = "../mod_gke"
  cluster_name    = "kubify-dev"
  location        = "us-central1"
  env_name		  = "dev"
}

module "aws" {
  source          = "../mod_eks"
  cluster_name    = "kubify-dev"
  location        = "us-east-1"
  env_name		  = "dev"
}

module "azure" {
  source          = "../mod_aks"
  cluster_name    = "kubify-dev"
  location        = "eastus"
  env_name		  = "dev"
}
