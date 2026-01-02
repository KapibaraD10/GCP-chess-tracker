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

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "build",
        "-t", "${var.region}-docker.pkg.dev/${var.project_id}/${var.repo_name}/${var.service_name}:$COMMIT_SHA",
        "-f", "src/Dockerfile",
        "./src"
      ]
    }
    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "push",
        "${var.region}-docker.pkg.dev/${var.project_id}/${var.repo_name}/${var.service_name}:$COMMIT_SHA"
      ]
    }
    step {
      name = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = [
        "run", "deploy", var.service_name,
        "--image", "${var.region}-docker.pkg.dev/${var.project_id}/${var.repo_name}/${var.service_name}:$COMMIT_SHA",
        "--region", var.region,
        "--platform", "managed",
        "--port", "8080",
        "--allow-unauthenticated"
      ]
    }
  }

  depends_on = [google_project_service.apis, google_artifact_registry_repository.repo]
}
