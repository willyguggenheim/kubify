# since dev, stage and prod use seperate accounts, only need 1 of these:
terraform {
  backend "s3" {
    bucket = "kubify-multicloud-state"
    key    = "kubify"
    region = "us-east-1"
  }
}