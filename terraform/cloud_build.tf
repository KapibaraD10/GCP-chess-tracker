# This file uses a 1st Generation Cloud Build trigger for a direct connection to GitHub.

# Create a 1st Generation Cloud Build trigger.
# This requires you to have connected your GitHub repository to Cloud Build
# via the GCP Console at least once.
resource "google_cloudbuild_trigger" "main_branch" {
  project  = var.project_id
  name     = "${var.service_name}-main-branch-trigger"
  location = "global" # 1st Gen GitHub triggers must be in the 'global' location

  # This block is for 1st Gen triggers and relies on the connection
  # made in the GCP Console.
  github {
    owner = var.github_owner
    name  = var.github_repo
    push { branch = "^main$" }
  }

  # Specify the dedicated service account for this trigger to run with.
  service_account = google_service_account.cloudbuild_sa.id

  # Point to a build configuration file in the repository
  filename = "cloudbuild.yaml"

  # Pass variables to the build
  substitutions = {
    _SERVICE_NAME = var.service_name
    _REGION       = var.region
    _REPO_NAME    = var.repo_name # This should be the Artifact Registry repo name, not the GitHub repo name.
  }

  # Ensure the Artifact Registry repo exists before creating the trigger.
  depends_on = [google_artifact_registry_repository.repo]
}
