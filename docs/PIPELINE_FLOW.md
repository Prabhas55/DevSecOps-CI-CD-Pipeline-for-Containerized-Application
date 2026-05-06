# Pipeline Flow — Step by Step

## Complete Flow

```
GitHub → Jenkins → SonarQube → Node/npm → OWASP → Docker → Trivy → DockerHub → Kubernetes → Slack + Splunk → Prometheus + Grafana
```

---

## Stage-by-Stage Breakdown

### 1. GitHub (Source)
- Developer pushes code to `main` branch
- Jenkins polls or webhook triggers the pipeline

### 2. Jenkins — Tool Install 
- JDK 17 and Node.js 16 are configured as tools
- Environment variable `SCANNER_HOME` set to SonarQube scanner path

### 3. Jenkins — Clean 
- `cleanWs()` wipes the workspace before every build
- Ensures a fresh, reproducible build environment

### 4. Jenkins — Code 
- Clones the GitHub repo (`main` branch)
- Source code lands in Jenkins workspace

### 5. SonarQube Analysis
- Runs `sonar-scanner` against the codebase
- Checks for bugs, vulnerabilities, code smells, duplications
- Results published to SonarQube dashboard

### 6. Quality Gates
- Jenkins waits for SonarQube to process results
- If gate **FAILS** → pipeline can be configured to abort
- In this project: `abortPipeline: false` (continue even if gate fails)
- **Result: Passed** — 0 bugs, 0 vulnerabilities, 20 code smells (A rating)

### 7. Install Dependencies
- `npm install` fetches all Node.js/React packages
- Results cached in `node_modules/`

### 8. OWASP Dependency-Check
- Scans `node_modules` and source for known CVEs
- Report saved as `dependency-check-report.xml`
- Jenkins publishes a **Dependency-Check Trend** graph
- Tracks High/Critical vulnerabilities across builds

### 9. Trivy Filesystem Scan
- `trivy fs . > trivyfs.txt`
- Scans all files in workspace for vulnerabilities
- Output saved for audit trail

### 10. Docker Build
- `docker build -t image1 .` — builds the container image
- Uses multi-stage Dockerfile (build → nginx serve)

### 11. Docker Build & Push
- Tags image as `shaikmustafa/loki:mydockerimage`
- Pushes to DockerHub using stored credentials

### 12. Trivy Image Scan
- `trivy image shaikmustafa/loki:mydockerimage`
- Scans the pushed image for OS and library vulnerabilities
- Results printed in build log (visible in Splunk)

### 13. Deploy to Kubernetes
- `kubectl apply -f k8s/deployment.yml`
- `kubectl apply -f k8s/service.yml`
- Pods pull image from DockerHub
- Service exposes app via AWS LoadBalancer

### 14. Post Actions — Slack & Splunk
- **Slack:** Sends SUCCESS (green) or FAILURE (red) to `#deployment`
- **Splunk:** All console logs forwarded to Splunk via HTTP Event Collector

---

## ArgoCD GitOps Flow

After the pipeline runs, ArgoCD watches the repo for changes to K8s manifests:

```
GitHub (k8s/*.yml changed) → ArgoCD detects → Auto-sync → K8s updated
```

- ArgoCD polls every 3 minutes or uses webhook
- Rollback possible via **History and Rollback** in ArgoCD UI

---

## Monitoring Flow

```
Kubernetes pods → Prometheus (scrapes metrics) → Grafana (visualizes)
```

Metrics available:
- Network I/O pressure per node
- Cluster-wide CPU, memory, filesystem usage
- Per-pod CPU usage
- Node health via Node Exporter (dashboard 1860)
