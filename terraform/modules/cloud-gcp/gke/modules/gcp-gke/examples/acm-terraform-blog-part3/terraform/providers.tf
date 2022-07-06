

terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "3.73.0"
    }
  }
}
provider "google-beta" {
  project = var.project
  region  = var.region
  zone    = var.zone
}
