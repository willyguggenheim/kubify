
module "aks-primary-westus" {
  source = "./aks/modules/kubify-aks/"

  cluster_name = var.cluster_name
  aks_region   = "westus"
}

module "aks-primary-eastus" {
  source = "./aks/modules/kubify-aks/"

  cluster_name = var.cluster_name
  aks_region   = "eastus"
}