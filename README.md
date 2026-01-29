# GCP Chess Tracker

A serverless web application that fetches and displays Lichess user statistics. Built with a React frontend and Python FastAPI backend, deployed on Google Cloud Platform.

## Features
- **Lichess Integration**: Real-time chess statistics fetching.
- **Modern UI**: Built with React and Vite.
- **Serverless**: Powered by Google Cloud Run.
- **CI/CD**: Automated deployment via Google Cloud Build.
- **Observability**: Custom metrics tracked in Google Cloud Monitoring.

## Architecture
- **Frontend**: React (Vite)
- **Backend**: FastAPI (Python)
- **Infrastructure**: Terraform
- **Platform**: Google Cloud (Cloud Run, Artifact Registry, Cloud Build)

## Local Development
Requires Docker.
```bash
# General build and run (if using standard Docker)
docker build -t chess-app src/
docker run -p 8080:8080 chess-app
```

## Deployment
Automated via GitHub push to the `main` branch.
1. Infrastructure managed via Terraform in `/terraform`.
2. Build pipeline defined in `cloudbuild.yaml`.
