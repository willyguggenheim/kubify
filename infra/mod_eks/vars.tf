variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
}

variable "subnets" {
  description = "List of subnets for EKS nodes."
  type        = array
  default 	  = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}