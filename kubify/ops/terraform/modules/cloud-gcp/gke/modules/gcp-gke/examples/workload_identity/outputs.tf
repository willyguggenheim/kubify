

output "kubernetes_endpoint" {
  sensitive = true
  value     = module.gke.endpoint
}

output "client_token" {
  sensitive = true
  value     = base64encode(data.google_client_config.default.access_token)
}

output "ca_certificate" {
  value = module.gke.ca_certificate
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke.service_account
}

output "region" {
  description = "Cluster region"
  value       = module.gke.region
}

output "location" {
  description = "Cluster location (zones)"
  value       = module.gke.location
}

output "project_id" {
  description = "Project id where GKE cluster is created."
  value       = var.project_id
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
}

# Default instantiation of WI module
output "default_wi_email" {
  description = "GCP service account."
  value       = module.workload_identity.gcp_service_account.email
}

output "default_wi_ksa_name" {
  description = "K8S SA name"
  value       = module.workload_identity.k8s_service_account_name
}

# Existing KSA instantiation of WI module
output "existing_ksa_email" {
  description = "GCP service account."
  value       = module.workload_identity_existing_ksa.gcp_service_account_email
}

output "existing_ksa_name" {
  description = "K8S SA name"
  value       = module.workload_identity_existing_ksa.k8s_service_account_name
}

# Existing GSA instantiation of WI module
output "existing_gsa_email" {
  description = "GCP service account."
  value       = google_service_account.custom.email
}

output "existing_gsa_name" {
  description = "K8S SA name"
  value       = module.workload_identity_existing_gsa.k8s_service_account_name
}
