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

## 🚢 Deployment

### 1. Infrastructure (Terraform)
To setup or update the GCP environment:
```powershell
cd terraform
terraform init
terraform apply
```

### 2. Application Code
There are two ways to deploy your code:

#### **A. Local Deployment (Recommended for testing)**
Use the provided PowerShell script to build and deploy immediately from your machine:
```powershell
.\deploy.ps1
```

#### **B. Automated CI/CD (GitHub)**
Push your changes to the `main` branch:
```bash
git add .
git commit -m "Your message"
git push origin main
```
*Note: Requires a one-time connection between GitHub and GCP Console.*

## 📊 Monitoring
The application exports custom metrics to **Google Cloud Monitoring**, allowing you to track API usage and performance in real-time.
