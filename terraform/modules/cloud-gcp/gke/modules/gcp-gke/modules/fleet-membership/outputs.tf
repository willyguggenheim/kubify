

output "cluster_membership_id" {
  description = "The ID of the hub membership"
  value       = var.enable_fleet_registration ? google_gke_hub_membership.primary[0].membership_id : local.gke_hub_membership_name
}

output "wait" {
  description = "An output to use when you want to depend on registration finishing"
  value       = var.enable_fleet_registration ? google_gke_hub_membership.primary[0].membership_id : local.gke_hub_membership_name
}
