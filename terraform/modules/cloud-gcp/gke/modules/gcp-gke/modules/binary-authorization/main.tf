

locals {
  required_enabled_apis = [
    "containeranalysis.googleapis.com",
    "binaryauthorization.googleapis.com",
    "container.googleapis.com",
    "cloudkms.googleapis.com"
  ]
}

module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.3"

  project_id    = var.project_id
  activate_apis = local.required_enabled_apis

  disable_services_on_destroy = var.disable_services_on_destroy
  disable_dependent_services  = var.disable_dependent_services
}

resource "google_binary_authorization_attestor" "attestor" {
  project = var.project_id
  name    = "${var.attestor-name}-attestor"
  attestation_authority_note {
    note_reference = google_container_analysis_note.build-note.name
    public_keys {
      id = data.google_kms_crypto_key_version.version.id
      pkix_public_key {
        public_key_pem      = data.google_kms_crypto_key_version.version.public_key[0].pem
        signature_algorithm = data.google_kms_crypto_key_version.version.public_key[0].algorithm
      }
    }
  }
}

resource "google_container_analysis_note" "build-note" {
  project = var.project_id
  name    = "${var.attestor-name}-attestor-note"
  attestation_authority {
    hint {
      human_readable_name = "${var.attestor-name} Attestor"
    }
  }
}

# KEYS

data "google_kms_crypto_key_version" "version" {
  crypto_key = google_kms_crypto_key.crypto-key.id
}

resource "google_kms_crypto_key" "crypto-key" {
  name     = "${var.attestor-name}-attestor-key"
  key_ring = var.keyring-id
  purpose  = "ASYMMETRIC_SIGN"

  version_template {
    algorithm = var.crypto-algorithm
  }

  lifecycle {
    prevent_destroy = false
  }
}
