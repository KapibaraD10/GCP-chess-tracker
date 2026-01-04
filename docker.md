# Dokumentacja Docker

Poniżej znajdują się pliki konfiguracyjne Dockera używane w projekcie oraz opis wymagań.

W projekcie znajduje się **jeden plik `Dockerfile`** (typu multi-stage), który buduje zarówno frontend (React), jak i backend (Python). Nie ma oddzielnych plików Dockerfile dla każdej z usług, ponieważ są one wdrażane jako pojedynczy kontener.

## 1. Pliki konfiguracyjne

### `docker-compose.yml`

```yaml
version: '3.8'

services:
  app:
    build:
      context: ./src
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      - PORT=8080
      - GOOGLE_CLOUD_PROJECT=local-project
    volumes:
      - ./src/backend:/app/backend
      # We don't mount frontend in this simple setup as it's built into the image
      # For live frontend dev, we'd run a separate node container or local vite dev server
```

### `src/Dockerfile`

```dockerfile
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
```

## 2. Wymagania i Opis Działania

### Co jest potrzebne do działania?

Ten kontener jest **samowystarczalny** (multi-stage build), co oznacza, że zawiera w sobie zarówno zbudowany frontend, jak i środowisko uruchomieniowe backendu.

**Wymagania systemowe / środowiskowe:**

1.  **Port 8080**: Kontener nasłuchuje na porcie 8080. Należy upewnić się, że ten port jest dostępny i przekierowany na zewnątrz (jak w `docker-compose.yml`).
2.  **Zmienne środowiskowe**:
    *   `PORT`: Domyślnie ustawione na `8080`.
    *   `GOOGLE_CLOUD_PROJECT`: Ustawione na ID projektu (lub `local-project` lokalnie, `gcp-chess-project` w obrazie). Jest to potrzebne dla bibliotek Google Cloud (np. Monitoring), jeśli są używane.
3.  **Dostęp do Internetu**:
    *   Podczas budowania (`docker build`):
        *   Obraz `node:18-alpine` musi pobrać zależności z npm (`npm install`).
        *   Obraz `python:3.11-slim` musi pobrać zależności z pip (`pip install`).
    *   Podczas działania (`run`):
        *   Aplikacja backendowa (`main.py`) potrzebuje dostępu do zewnętrznego API Lichess (`https://lichess.org/api/user/{username}`).
        *   Jeśli włączone są metryki GCP, potrzebny jest dostęp do API Google Cloud (wymaga odpowiednich poświadczeń/Role IAM jeśli działa w chmurze, lub `gcloud auth application-default login` lokalnie).

### Struktura Kontenera

*   **Baza**: Linux (`python:3.11-slim` oparty na Debianie).
*   **Serwer**: `uvicorn` uruchamia aplikację FastAPI.
*   **Frontend**: Zbudowane pliki statyczne Reacta (z fazy `build`) znajdują się w `/frontend/dist` i są serwowane przez FastAPI pod głównym adresem `/`.
