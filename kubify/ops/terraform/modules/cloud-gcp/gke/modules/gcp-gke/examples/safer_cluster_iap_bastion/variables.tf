

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = "safer-cluster-iap-bastion"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "us-central1"

}

variable "network_name" {
  type        = string
  description = "The name of the network being created to host the cluster in"
  default     = "safer-cluster-network"
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet being created to host the cluster in"
  default     = "safer-cluster-subnet"
}

variable "subnet_ip" {
  type        = string
  description = "The cidr range of the subnet"
  default     = "10.10.10.0/24"
}

variable "ip_range_pods_name" {
  type        = string
  description = "The secondary ip range to use for pods"

  default = "ip-range-pods"
}

variable "ip_range_services_name" {
  type        = string
  description = "The secondary ip range to use for pods"

  default = "ip-range-svc"
}

variable "bastion_members" {
  type        = list(string)
  description = "List of users, groups, SAs who need access to the bastion host"
  default     = []
}
