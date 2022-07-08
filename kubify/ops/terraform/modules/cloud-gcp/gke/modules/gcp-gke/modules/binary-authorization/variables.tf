

variable "project_id" {
  type        = string
  description = "Project ID to apply services into"
}

variable "attestor-name" {
  type        = string
  description = "Name of the attestor"
}

variable "keyring-id" {
  type        = string
  description = "Keyring ID to attach attestor keys"
}

variable "crypto-algorithm" {
  type        = string
  default     = "RSA_SIGN_PKCS1_4096_SHA512"
  description = "Algorithm used for the async signing keys"
}

variable "disable_services_on_destroy" {
  description = "Whether project services will be disabled when the resources are destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy"
  default     = false
  type        = bool
}

variable "disable_dependent_services" {
  description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services"
  default     = false
  type        = bool
}
