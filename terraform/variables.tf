variable "project_id" {
  description = "The GCP project ID to deploy resources into."
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources into."
  type        = string
  default     = "europe-central2"
}

variable "service_name" {
  description = "The name of the Cloud Run service."
  type        = string
  default     = "chess-app"
}

variable "repo_name" {
  description = "The name of the Artifact Registry repository."
  type        = string
  default     = "chess-app-repo"
}

variable "github_owner" {
  description = "The owner of the GitHub repository."
  type        = string
  default     = "KapibaraD10"
}

variable "github_repo" {
  description = "The name of the GitHub repository."
  type        = string
  default     = "GCP-chess-tracker"
}