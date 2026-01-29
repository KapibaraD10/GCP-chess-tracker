import base64
import requests
import sys

# Define the Mermaid diagram syntax
mermaid_graph = """
%%{init: {'theme': 'base', 'themeVariables': { 'fontSize': '18px', 'fontFamily': 'Roboto, Segoe UI, sans-serif'}, 'flowchart': {'nodeSpacing': 120, 'rankSpacing': 150, 'curve': 'basis'}} }%%
graph LR
    %% Styles - Premium look
    classDef default fill:#ffffff,stroke:#333,stroke-width:1px;
    classDef gcp fill:#fff,stroke:#4285F4,stroke-width:2px,rx:10,ry:10;
    classDef external fill:#f8f9fa,stroke:#adb5bd,stroke-width:2px,rx:10,ry:10;
    classDef userNode fill:#e8f0fe,stroke:#1967d2,stroke-width:2px,rx:50,ry:50;

    %% Nodes
    subgraph External["External Services"]
        direction TB
        Developer("fa:fa-github GitHub<br/>(Source Repository)"):::external
        UserNode("fa:fa-user User<br/>(Browser)"):::userNode
        Lichess("fa:fa-chess Lichess API<br/>(Stats Source)"):::external
    end

    subgraph GCP["Google Cloud Platform"]
        direction LR
        
        subgraph CICD["CI/CD Pipeline"]
            direction TB
            Build("Cloud Build<br/>(Automation)"):::gcp
            Registry("Artifact Registry<br/>(Docker Images)"):::gcp
        end

        subgraph Runtime["Compute & Hosting"]
            Run("Cloud Run<br/>(React + FastAPI)"):::gcp
        end

        subgraph Monitoring["Observability"]
            Monitor("Cloud Monitoring<br/>(Custom Metrics)"):::gcp
        end
    end

    %% Flow
    Developer -- "Push Code" --> Build
    Build -- "Containerize" --> Registry
    Build -- "Triggers" --> Run
    
    Registry -. "Pull Latest" .-> Run
    
    UserNode -- "HTTPS /api" --> Run
    Run -- "Fetch Global Stats" --> Lichess
    Run -- "Publish Metrics" --> Monitor

    %% Apply Classes
    class Build,Registry,Run,Monitor gcp;
"""

def generate_diagram():
    # 1. Encode the graph to base64
    graph_bytes = mermaid_graph.encode('utf-8')
    base64_bytes = base64.b64encode(graph_bytes)
    base64_string = base64_bytes.decode('ascii')

    # 2. Construct the URL (using mermaid.ink service)
    url = f"https://mermaid.ink/img/{base64_string}"

    print(f"Fetching diagram from: {url}")
    print("Downloading...")

    try:
        response = requests.get(url)
        if response.status_code == 200:
            output_filename = "gcp_chess_tracker_architecture.png"
            with open(output_filename, 'wb') as f:
                f.write(response.content)
            print(f"Success! Diagram saved to: {output_filename}")
        else:
            print(f"Error fetching image. Status code: {response.status_code}")
            print(response.text)
    except Exception as e:
        print(f"Exception occurred: {e}")
        print("Ensure you have internet access and the 'requests' library installed.")

if __name__ == "__main__":
    generate_diagram()
