terraform {
  backend "s3" {
    bucket = "kubify-tf-state"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}