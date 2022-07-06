terraform {
  backend "s3" {
    bucket = "kubify-tf-state"
    key    = "kubify"
    region = "us-west-2"
  }
}