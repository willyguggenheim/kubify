output "name" {
  value = module.aks-primary-westus.name
}

output "id" {
  value = module.aks-primary-westus.id
}

output "fqdn" {
  value = module.aks-primary-westus.fqdn
}

output "private_fqdn" {
  value = module.aks-primary-westus.private_fqdn
}

output "kube_admin_config_raw" {
  value = module.aks-primary-westus.kube_admin_config_raw
}

output "kube_config_raw" {
  value = module.aks-primary-westus.kube_config_raw
}

output "node_resource_group" {
  value = module.aks-primary-westus.node_resource_group
}

output "kubelet_identity" {
  value = module.aks-primary-westus.kubelet_identity
}

output "identity" {
  value = module.aks-primary-westus.identity
}

################################################################################
################################################################################
################################################################################

################################################################################
##### DR OUTPUTS ###############################################################
################################################################################

output "dr_name" {
  value = module.aks-primary-eastus.name
}

output "dr_id" {
  value = module.aks-primary-eastus.id
}

output "dr_fqdn" {
  value = module.aks-primary-eastus.fqdn
}

output "dr_private_fqdn" {
  value = module.aks-primary-eastus.private_fqdn
}

output "dr_kube_admin_config_raw" {
  value = module.aks-primary-eastus.kube_admin_config_raw
}

output "dr_kube_config_raw" {
  value = module.aks-primary-eastus.kube_config_raw
}

output "dr_node_resource_group" {
  value = module.aks-primary-eastus.node_resource_group
}

output "dr_kubelet_identity" {
  value = module.aks-primary-eastus.kubelet_identity
}

output "dr_identity" {
  value = module.aks-primary-eastus.identity
}