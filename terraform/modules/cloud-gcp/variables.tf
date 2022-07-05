variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "gke-on-vpc-cluster"
}
variable "project_id" {
  description = "The project ID to host the cluster in"
}