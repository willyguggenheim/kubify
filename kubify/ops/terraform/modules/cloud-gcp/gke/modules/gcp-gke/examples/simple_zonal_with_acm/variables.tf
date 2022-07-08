

variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "cluster_name_suffix" {
  description = "A suffix to append to the default cluster name"
  default     = ""
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "The zone to host the cluster in"
  default     = "us-central1-a"
}
