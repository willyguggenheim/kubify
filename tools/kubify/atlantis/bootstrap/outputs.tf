output "public_key" {
  value = "${tls_private_key.infrastructure_modules_deploy_key.public_key_openssh}"
}

output "atlantis_url" {
  description = "URL of Atlantis"
  value       = "${module.atlantis.atlantis_url}"
}

output "atlantis_url_events" {
  description = "Webhook events URL of Atlantis"
  value       = "${module.atlantis.atlantis_url_events}"
}

output "atlantis_allowed_repo_names" {
  description = "Github repositories where webhook should be created"
  value       = "${var.atlantis_allowed_repo_names}"
}

output "webhook_secret" {
  description = "Webhook secret"
  value       = "${module.atlantis.webhook_secret}"
}
