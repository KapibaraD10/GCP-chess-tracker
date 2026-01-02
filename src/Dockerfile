# Stage 1: Build React App
FROM node:18-alpine as build
WORKDIR /app
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# Stage 2: Python Backend
FROM python:3.11-slim

WORKDIR /app

# Copy requirements and install
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend code
COPY backend/ .

# Copy built frontend static files
COPY --from=build /app/dist /frontend/dist

# Expose port
EXPOSE 8080

# Environment variables
ENV PORT=8080
ENV GOOGLE_CLOUD_PROJECT=gcp-chess-project

# Run app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
