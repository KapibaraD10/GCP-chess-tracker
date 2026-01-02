import os
import time
import requests
from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from google.cloud import monitoring_v3

app = FastAPI()

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# GCP Project ID setup
PROJECT_ID = os.environ.get("GOOGLE_CLOUD_PROJECT", "local-project")

# Initialize Monitoring Client (only if in GCP or with credentials)
try:
    client = monitoring_v3.MetricServiceClient()
    project_name = f"projects/{PROJECT_ID}"
except Exception as e:
    print(f"Warning: Could not initialize Monitoring Client: {e}")
    client = None

def report_search_metric(username: str):
    """Reports a custom metric for user searches."""
    if not client or PROJECT_ID == "local-project":
        print(f"Skipping metric report for {username} (local mode)")
        return

    series = monitoring_v3.TimeSeries()
    series.metric.type = "custom.googleapis.com/chess_app/user_searches"
    series.resource.type = "global"
    
    # Add a point
    now = time.time()
    seconds = int(now)
    nanos = int((now - seconds) * 10**9)
    interval = monitoring_v3.TimeInterval(
        {"end_time": {"seconds": seconds, "nanos": nanos}}
    )
    point = monitoring_v3.Point({"interval": interval, "value": {"int64_value": 1}})
    series.points = [point]

    try:
        client.create_time_series(name=project_name, time_series=[series])
        print(f"Reported metric for {username}")
    except Exception as e:
        print(f"Failed to report metric: {e}")

@app.get("/api/user/{username}")
def get_lichess_user(username: str):
    # Report metric
    report_search_metric(username)

    url = f"https://lichess.org/api/user/{username}"
    response = requests.get(url)
    
    if response.status_code == 404:
        raise HTTPException(status_code=404, detail="User not found")
    if response.status_code != 200:
        raise HTTPException(status_code=500, detail="Lichess API error")
    
    return response.json()

# Serve static files (React build) - will be populated in Docker build
# We can conditionally mount this to avoid errors during local dev if folder missing
if os.path.exists("../frontend/dist"):
    app.mount("/", StaticFiles(directory="../frontend/dist", html=True), name="static")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
