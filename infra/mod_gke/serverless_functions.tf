resource "google_storage_bucket" "bucket" {
  name                = var.functions
}

resource "google_storage_bucket_object" "archive" {
  name   = "index.zip"
  bucket = google_storage_bucket.bucket.name
  source = "../../backend/example-lambda-python-svc/app"
}

resource "google_cloudfunctions_function" "function" {
  name        = var.functions
  description = var.functions
  runtime     = "python3"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  # artifact that has the function's code
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "entrypoint"
}

# IAM entry for all users to invoke the function
#resource "google_cloudfunctions_function_iam_member" "invoker" {
#  project        = google_cloudfunctions_function.function.project
#  region         = google_cloudfunctions_function.function.region
#  cloud_function = google_cloudfunctions_function.function.name
#
#  role   = "roles/cloudfunctions.invoker"
#  member = "functions-read-telemetry"
#}