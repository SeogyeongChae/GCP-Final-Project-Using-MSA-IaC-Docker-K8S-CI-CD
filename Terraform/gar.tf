# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository
resource "google_artifact_registry_repository" "gcpzg_gar" {
  repository_id = "gcpzg-gar" # Required | Name of gar
  format        = "DOCKER" # Required | The format of packages
  location      = "asia-northeast3"
}