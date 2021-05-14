### AKS Kubernetes Cluster:

resource "azurerm_resource_group" "kubify_aks" {
  name     = "kubify_aks"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "kubify_aks" {
  name                = "kubify_aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.kubify_aks.name
  dns_prefix          = "kubify-${var.env_name}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    env = var.env_name
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.kubify_aks.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.kubify_aks.kube_config_raw
}