output "project_id" {
  value = var.project_id
}

output "region" {
  value = module.gke.region
}

output "network" {
  value = var.network
}

output "subnetwork" {
  value = var.subnetwork
}

output "location" {
  value = module.gke.location
}

output "ip_range_pods_name" {
  description = "The secondary IP range used for pods"
  value       = var.ip_range_pods_name
}

output "ip_range_services_name" {
  description = "The secondary IP range used for services"
  value       = var.ip_range_services_name
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = module.gke.zones
}

output "master_kubernetes_version" {
  description = "The master Kubernetes version"
  value       = module.gke.master_version
}
