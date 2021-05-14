# Terraform self
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}


#_____________________________________________

#GCP Project

provider "google" {}

resource "google_project" "my_project" {
  name       = "kubify-${var.env_name}"
  policy_data = "${data.google_iam_policy.devops.policy_data}"
}

data "google_iam_policy" "devops" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = [
      "user:willy-devops@gugcorp.com",
    ]
  }
}

# or can use roles/cloudfunctions.developer if want full cloudfunctions access
# for reference on roles and default permissions: https://cloud.google.com/iam/docs/understanding-roles 

resource "google_project_iam_custom_role" "functions-read-telemetry" {
  role_id     = "functions-read-telemetry"
  title       = "functions-read-telemetry"
  description = "Ability to read the telemetry of a deployed Serverless Function"
  permissions = [
    "cloudfunctions.functions.get", 
    "cloudfunctions.functions.list"
    ]
}

data "google_iam_policy" "functions-read-telemetry" {
  binding {
    role = google_project_iam_custom_role.functions-read-telemetry

    members = var.users
  }
}

