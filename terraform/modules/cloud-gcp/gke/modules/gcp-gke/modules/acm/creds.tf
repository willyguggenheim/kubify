

resource "tls_private_key" "k8sop_creds" {
  count     = var.create_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Wait for the ACM operator to create the namespace
resource "time_sleep" "wait_acm" {
  count      = (var.create_ssh_key == true || var.ssh_auth_key != null) ? 1 : 0
  depends_on = [google_gke_hub_feature_membership.main]

  create_duration = "60s"
}

resource "kubernetes_secret_v1" "creds" {
  count      = (var.create_ssh_key == true || var.ssh_auth_key != null) ? 1 : 0
  depends_on = [time_sleep.wait_acm]

  metadata {
    name      = "git-creds"
    namespace = "config-management-system"
  }

  data = {
    "${local.k8sop_creds_secret_key}" = local.private_key
  }
}
