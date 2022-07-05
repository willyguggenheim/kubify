output "kubernetes_endpoint" {
  description = "The cluster endpoint"
  sensitive   = true
  value       = module.gke-primary-west2.kubernetes_endpoint
}

output "client_token" {
  description = "The bearer token for auth"
  sensitive   = true
  value       = module.gke-primary-west2.client_token
}

output "ca_certificate" {
  description = "The cluster ca certificate (base64 encoded)"
  value       = module.gke-primary-west2.ca_certificate
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke-primary-west2.service_account
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke-primary-west2.cluster_name
}

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.gke-primary-west2.network_name
}

output "subnet_name" {
  description = "The name of the subnet being created"
  value       = module.gke-primary-west2.subnet_name
}

output "subnet_secondary_ranges" {
  description = "The secondary ranges associated with the subnet"
  value       = module.gke-primary-west2.subnet_secondary_ranges
}

################################################################################
################################################################################
################################################################################

################################################################################
##### DR OUTPUTS ###############################################################
################################################################################

output "dr_kubernetes_endpoint" {
  description = "The cluster endpoint"
  sensitive   = true
  value       = module.gke-primary-east1.kubernetes_endpoint
}

output "dr_client_token" {
  description = "The bearer token for auth"
  sensitive   = true
  value       = module.gke-primary-east1.client_token
}

output "dr_ca_certificate" {
  description = "The cluster ca certificate (base64 encoded)"
  value       = module.gke-primary-east1.ca_certificate
}

output "dr_service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke-primary-east1.service_account
}

output "dr_cluster_name" {
  description = "Cluster name"
  value       = module.gke-primary-east1.cluster_name
}

output "dr_network_name" {
  description = "The name of the VPC being created"
  value       = module.gke-primary-west2.network_name
}

output "dr_subnet_name" {
  description = "The name of the subnet being created"
  value       = module.gke-primary-west2.subnet_name
}

output "dr_subnet_secondary_ranges" {
  description = "The secondary ranges associated with the subnet"
  value       = module.gke-primary-west2.subnet_secondary_ranges
}