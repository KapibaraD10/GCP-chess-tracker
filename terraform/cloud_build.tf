resource "google_cloudbuild_trigger" "build_main" {
  name        = "chess-app-main-trigger"
  description = "Build and deploy on push to main"
  
  # This relies on the repo being connected manually in the console first
  # or via the google_cloudbuildv2_repository resource if we used the 
  # newer 2nd gen repository connection (which requires more setup).
  # For simplicity with the standard trigger:
  
  github {
    owner = var.github_owner
    name  = var.github_repo
    push {
      branch = "^main$"
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _REGION       = var.region
    _REPO_NAME    = var.repo_name
    _SERVICE_NAME = var.service_name
  }

  depends_on = [google_project_service.apis, google_artifact_registry_repository.repo]
}
