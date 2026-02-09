# Deployment script for GCP Chess Tracker
# Requires Google Cloud CLI (gcloud) installed and authenticated.

$PROJECT_ID = "kapibara-cloud"
$REGION = "europe-central2"
$SERVICE_NAME = "chess-app"
$REPO_NAME = "chess-app-repo"

Write-Host "Checking gcloud status..." -ForegroundColor Cyan
if (!(Get-Command gcloud -ErrorAction SilentlyContinue)) {
    Write-Error "gcloud not found. Please install Google Cloud SDK: https://cloud.google.com/sdk/docs/install#windows"
    exit
}

Write-Host "Setting project to $PROJECT_ID..." -ForegroundColor Cyan
gcloud config set project $PROJECT_ID

Write-Host "Getting current commit hash..." -ForegroundColor Cyan
$COMMIT_SHA = $(git rev-parse --short HEAD)

Write-Host "Submitting build to Google Cloud (Commit: $COMMIT_SHA)..." -ForegroundColor Cyan
gcloud builds submit --config cloudbuild.yaml `
    --substitutions="_REGION=$REGION,_REPO_NAME=$REPO_NAME,_SERVICE_NAME=$SERVICE_NAME,COMMIT_SHA=$COMMIT_SHA"

Write-Host "Deployment complete! Retrieving service URL..." -ForegroundColor Green
gcloud run services describe $SERVICE_NAME --region $REGION --format='value(status.url)'
