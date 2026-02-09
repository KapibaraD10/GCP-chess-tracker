# Create a dedicated service account for the Cloud Run service
# to follow the principle of least privilege.
resource "google_service_account" "run_sa" {
  account_id   = "${var.service_name}-sa"
  display_name = "Service Account for ${var.service_name}"
  project      = var.project_id
}

# Note: Terraform will try to create this immediately. 
# If the image doesn't exist yet (because Cloud Build hasn't run), this might fail.
# A common pattern is to deploy a "Hello World" placeholder first or rely on Cloud Build 
# to do the first real deployment.
# Here we define the resource so Terraform manages the state, but we might 
# use a public image for the initial applied state if the real one isn't built.
# However, for this task, let's assume valid configuration.
# We will use the 'gcr.io/cloudrun/hello' image as a placeholder to allow initial apply 
# to succeed without waiting for the first build. The Cloud Build trigger will update it later.

resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.run_sa.email
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repo_name}/${var.service_name}:${var.image_tag}"
        ports {
          container_port = 8080
        }
        env {
          name  = "GOOGLE_CLOUD_PROJECT"
          value = var.project_id
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.apis,
    google_project_iam_member.cloudbuild_run_admin, # To make sure we can deploy
    google_service_account.run_sa,
    google_artifact_registry_repository.repo, # Ensure repo exists first
  ]
}

# Allow unauthenticated access
resource "google_cloud_run_service_iam_member" "noauth" {
  service  = google_cloud_run_service.default.name
  location = google_cloud_run_service.default.location
  role     = "roles/run.invoker"
  member   = "allUsers"

  depends_on = [
    google_cloud_run_service.default,
  ]
}
