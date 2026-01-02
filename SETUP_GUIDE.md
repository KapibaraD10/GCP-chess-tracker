# Setup Guide for GCP Chess App

## 1. Google Cloud Project Setup
1. **Create a Project**: Go to the Google Cloud Console and create a new project.
2. **Billing**: Enable billing for the project.
3. **APIs**: Ensure the following APIs are enabled (Terraform will attempt to enable them, but having them enabled helps):
    - Cloud Run API
    - Cloud Build API
    - Artifact Registry API
    - Stackdriver Monitoring API (Cloud Monitoring)

## 2. GitHub Connection for Cloud Build
**Crucial Manual Step**:
1. Go to [Cloud Build triggers page](https://console.cloud.google.com/cloud-build/triggers).
2. Click **Connect Repository**.
3. Select **GitHub** and follow the authorization flow to install "Google Cloud Build" GitHub App on your account/repository.
4. Once connected, Terraform can manage the trigger, but the connection (OAuth token) must be established manually in the console first.

## 3. Terraform Setup
1. Install [Terraform](https://developer.hashicorp.com/terraform/install).
2. Install [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install).
3. Authenticate locally:
   ```bash
   gcloud auth application-default login
   ```
4. Update `terraform/terraform.tfvars` (or create it) with your project ID:
   ```hcl
   project_id = "your-project-id"
   region     = "us-central1"
   ```

## 4. Deployment
1. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Apply configuration:
   ```bash
   terraform apply
   ```
   Type `yes` to confirm.
4. This will create the Artifact Registry repo, Cloud Build trigger, and Cloud Run service.

## 5. Local Development
To run the app locally without GCP dependencies:
```bash
docker-compose up --build
```
Access at `http://localhost:8080`.
