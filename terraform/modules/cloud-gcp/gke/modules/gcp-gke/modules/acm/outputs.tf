

output "git_creds_public" {
  description = "Public key of SSH keypair to allow the Anthos Config Management Operator to authenticate to your Git repository."
  value       = var.create_ssh_key ? coalesce(tls_private_key.k8sop_creds.*.public_key_openssh...) : null
}

output "wait" {
  description = "An output to use when you want to depend on cmd finishing"
  value       = google_gke_hub_feature_membership.main.membership
  depends_on = [
    google_gke_hub_feature_membership.main
  ]
}
