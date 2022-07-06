

variable "project" {
  type        = string
  description = "the GCP project where the cluster will be created"
}

variable "region" {
  type        = string
  description = "the GCP region where the cluster will be created"
}

variable "zone" {
  type        = string
  description = "the GCP zone in the region where the cluster will be created"
}

variable "sync_repo" {
  type        = string
  description = "git URL for the repo which will be sync'ed into the cluster via Config Management"
}

variable "sync_branch" {
  type        = string
  description = "the git branch in the repo to sync"
}

variable "policy_dir" {
  type        = string
  description = "the root directory in the repo branch that contains the resources."
}
