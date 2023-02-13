resource "google_storage_bucket" "gcpzg_gcs" {
  name          = "gcpzg-logging"
  location      = "asia-northeast3" # https://cloud.google.com/storage/docs/locations
  force_destroy = false
  storage_class = "COLDLINE" # Default = STANDARD
  public_access_prevention = "enforced"
}