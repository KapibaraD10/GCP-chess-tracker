# GCP Chess Tracker ♟️

A serverless web application that fetches and displays Lichess user statistics. This project demonstrates a modern full-stack architecture deployed on **Google Cloud Platform** using **Terraform** for Infrastructure as Code (IaC).

## 🚀 Live Demo
Access the application here: **[https://chess-app-fb5fcaevia-lm.a.run.app](https://chess-app-fb5fcaevia-lm.a.run.app)**

## 🏗️ Architecture
The project follows a serverless architecture for scalability and cost-efficiency:
- **Frontend**: React (Vite) - Single Page Application.
- **Backend**: FastAPI (Python) - Handles logic and external API calls.
- **Infrastructure**: Terraform - Manages GCP resources.
- **CI/CD**: Google Cloud Build - Automated builds triggered by GitHub or locally.
- **Storage**: Artifact Registry - Stores Docker images.
- **Execution**: Cloud Run - Serverless compute platform.

## 🛠️ Local Development

### Prerequisites
- Python 3.9+
- Node.js & npm
- Google Cloud CLI (gcloud)
- Terraform

### Setup
1. **Clone the repo**:
   ```bash
   git clone https://github.com/KapibaraD10/GCP-chess-tracker.git
   cd GCP-chess-tracker
   ```
2. **Local Backend**:
   ```bash
   cd src/backend
   pip install -r requirements.txt
   uvicorn main:app --reload
   ```

## 🚢 Deployment (Automated)

The project uses a fully automated CI/CD pipeline. No manual deployment scripts are required.

### 1. Infrastructure (Terraform)
Infrastructure is managed as code. To apply changes to the GCP environment:
```powershell
cd terraform
terraform init
terraform apply
```

### 2. Application Code (CI/CD)
The application is automatically built and deployed whenever changes are pushed to the `main` branch:
1. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Your descriptive message"
   ```
2. **Push to GitHub**:
   ```bash
   git push origin main
   ```
Google Cloud Build will detect the push, build a new Docker image, and update the Cloud Run service automatically.

## 📊 Monitoring
The application exports custom metrics to **Google Cloud Monitoring**, allowing you to track API usage and performance in real-time.
