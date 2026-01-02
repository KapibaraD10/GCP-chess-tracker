resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = var.repo_name
  description   = "Docker repository for Chess App"
  format        = "DOCKER"
  
  depends_on = [google_project_service.apis]
}
