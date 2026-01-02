variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The GCP Region"
  type        = string
  default     = "us-central1"
}

variable "repo_name" {
  description = "Name of the Artifact Registry repository"
  type        = string
  default     = "chess-app-repo"
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "chess-app"
}

variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
  default     = "KapibaraD10"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "GCP-chess-tracker"
}
