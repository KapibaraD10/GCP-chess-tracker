# Cloud Build Service Account needs permission to deploy to Cloud Run
resource "google_project_iam_member" "build_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "build_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# Cloud Run SA needs permission to write metrics
# By default Cloud Run uses the Compute Engine default service account.
# It usually has Editor, but best practice is a dedicated SA. 
# For simplicity, we'll ensure the default one has Monitoring Metric Writer.
resource "google_project_iam_member" "run_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

data "google_project" "project" {}
