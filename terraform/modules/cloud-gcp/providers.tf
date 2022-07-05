provider "google" {
  project = "kubify-os"
  region  = "us-central1"
  zone    = "us-central1-c"
}

provider "google-beta" {
  project = "kubify-os"
  region  = "us-central1"
  zone    = "us-central1-c"
}

data "google_client_config" "default" {}