variable "cluster_name" {
  description = "should match the file name envs/[cluster_name].yaml"
}
variable "gcp_project_id" {
  description = "The Google Cloud Project ID to host the cluster in"
  default     = "kubify-os"
}