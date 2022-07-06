

output "project_id" {
  description = "The GCP project you enabled APIs on"
  value       = module.services.project_id
}
