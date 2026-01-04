# Create a dedicated service account for Cloud Build to use for running builds.
resource "google_service_account" "cloudbuild_sa" {
  account_id   = "${var.service_name}-builder-sa"
  display_name = "Cloud Build SA for ${var.service_name}"
  project      = var.project_id
}

# Grant the new Cloud Build SA the Cloud Run Admin role to deploy services.
resource "google_project_iam_member" "cloudbuild_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = google_service_account.cloudbuild_sa.member
}

# Grant the new Cloud Build SA the ability to act as (impersonate) the Cloud Run service's SA.
resource "google_service_account_iam_member" "cloudbuild_act_as_run_sa" {
  service_account_id = google_service_account.run_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = google_service_account.cloudbuild_sa.member
}

# Grant the new Cloud Build SA permission to write to the Artifact Registry repository.
# This is more secure than granting project-wide storage permissions.
resource "google_artifact_registry_repository_iam_member" "cloudbuild_artifact_writer" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.repo.name
  role       = "roles/artifactregistry.writer"
  member     = google_service_account.cloudbuild_sa.member
}