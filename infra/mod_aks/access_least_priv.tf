# Terraform self
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}





#_____________________________________________

# Create Users
resource "azuread_user" "users" {
  user_principal_name = var.users
  display_name        = var.users
  mail_nickname       = var.users
  password            = random_password.password.result
  count               = "${var.users ? 1 : 0}"
}

# Pull in information on project owner
data "azuread_user" "adu-project-owner" {
  user_principal_name = var.project_owner
}

# Pull in information on Azure DevOps User group
data "azuread_group" "azdo-user" {
  name = "gAZAzureDevOpsUser"
}

# AAD Groups
resource "azuread_group" "functions-read-telemetry" {
  name   = "kubify-functions-read-telemetry"
  owners = [data.azuread_user.adu-project-owner.id]
  members = var.users
}










