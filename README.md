# 🎮 DevSecOps Tetris Game — Full Pipeline Project

> A production-grade DevSecOps pipeline deploying a React Tetris game on Kubernetes using industry-standard tools for CI/CD, security scanning, monitoring, and alerting.

---

## 🏗️ Pipeline Architecture

```
GitHub → Jenkins → SonarQube → Node/npm → OWASP → Docker → Trivy → DockerHub → Kubernetes (KOPS) → Splunk & Slack → Prometheus & Grafana
```

```
┌──────────┐    ┌─────────┐    ┌───────────┐    ┌──────┐    ┌───────┐
│  GitHub  │───▶│ Jenkins │───▶│ SonarQube │───▶│ OWASP│───▶│Trivy  │
└──────────┘    └─────────┘    └───────────┘    └──────┘    └───────┘
                                                                  │
                ┌─────────┐    ┌───────────┐    ┌──────────┐     │
                │Prometheus│◀──│Kubernetes │◀───│ DockerHub│◀────┘
                │ Grafana  │   │  (KOPS)   │    └──────────┘
                └─────────┘    └─────┬─────┘
                                     │
                          ┌──────────┴──────────┐
                          │   Slack  │  Splunk   │
                          └──────────┴──────────┘
```

---

## 🛠️ Tools & Technologies

| Stage | Tool | Purpose |
|-------|------|---------|
| Source Control | GitHub | Code repository & version control |
| CI/CD | Jenkins | Pipeline automation |
| Code Quality | SonarQube | Static code analysis & quality gates |
| Build | Node.js 16 / npm | Frontend dependency management |
| Security Scan | OWASP Dependency-Check | Vulnerability scanning of dependencies |
| Containerization | Docker | Build & tag application image |
| Image Scan | Trivy | Container image vulnerability scanning |
| Registry | DockerHub | Container image storage |
| Orchestration | Kubernetes (KOPS) | Container orchestration on AWS |
| Notifications | Slack | Build success/failure alerts |
| Log Analysis | Splunk | Jenkins build log aggregation |
| Monitoring | Prometheus + Grafana | Cluster metrics & dashboards |

---

## 📁 Repository Structure

```
devsecops-tetris/
├── README.md
├── Dockerfile
├── Jenkinsfile                          # Main CI/CD pipeline
├── sonar-project.properties             # SonarQube config
├── .github/
│   └── workflows/
│       └── pr-check.yml                 # GitHub Actions PR checks
├── jenkins/
│   └── setup-guide.md                   # Jenkins setup instructions
├── k8s/
│   ├── deployment.yml                   # Kubernetes Deployment
│   └── service.yml                      # Kubernetes Service (LoadBalancer)
├── monitoring/
│   ├── prometheus-setup.md              # Prometheus install guide
│   └── grafana-setup.md                 # Grafana dashboard setup
├── scripts/
│   ├── install-jenkins.sh               # Jenkins server setup
│   ├── install-trivy.sh                 # Trivy installation
│   └── kops-cluster.sh                  # KOPS cluster creation
└── docs/
    ├── PIPELINE_FLOW.md                 # Detailed pipeline walkthrough
    ├── SLACK_INTEGRATION.md             # Slack notification setup
    └── SPLUNK_INTEGRATION.md            # Splunk integration guide
```

---

## 🚀 Quick Start

### Prerequisites
- AWS Account with EC2 access
- A t2.large EC2 instance for Jenkins
- DockerHub account
- Slack workspace
- Domain or S3 bucket for KOPS state store

### Step 1 — Launch Jenkins Server
```bash
# Launch t2.large EC2 instance (Ubuntu 22.04), then:
chmod +x scripts/install-jenkins.sh
./scripts/install-jenkins.sh
```

### Step 2 — Install Trivy
```bash
chmod +x scripts/install-trivy.sh
./scripts/install-trivy.sh
```

### Step 3 — Run the Jenkins Pipeline
- Open Jenkins at `http://<EC2-IP>:8080`
- Create a new Pipeline job named `Tetrics-v1`
- Point it to this repository's `Jenkinsfile`
- Configure credentials (DockerHub, SonarQube token, Slack token)
- Click **Build Now**

### Step 4 — Create Kubernetes Cluster
```bash
chmod +x scripts/kops-cluster.sh
./scripts/kops-cluster.sh
```

### Step 5 — Deploy via ArgoCD
```bash
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Expose ArgoCD
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

### Step 6 — Set Up Monitoring
See [`monitoring/prometheus-setup.md`](monitoring/prometheus-setup.md) and [`monitoring/grafana-setup.md`](monitoring/grafana-setup.md)

---

## 📸 Project Screenshots

| Component | Description |
|-----------|-------------|
| Jenkins Pipeline | All stages passing (Clean → Code → Sonar → OWASP → Trivy → Docker → K8s) |
| SonarQube | Quality Gate: **Passed** — 0 bugs, 0 vulnerabilities |
| ArgoCD | App health: **Healthy**, Sync status: **Synced** |
| Grafana | K8s cluster memory: 37.1%, CPU: 0.78% |
| Slack | Real-time SUCCESS/FAILURE notifications per build |
| Splunk | Build Analysis dashboard with full Jenkins logs |
| App | React Tetris game live on K8s LoadBalancer |

---

## 🔐 Jenkins Credentials Required

| Credential ID | Type | Description |
|---------------|------|-------------|
| `docker-password` | Username/Password | DockerHub credentials |
| `sonar-token` | Secret Text | SonarQube user token |
| `slack-token` | Secret Text | Slack bot integration token |

---

## 📖 Documentation

- [Pipeline Flow](docs/PIPELINE_FLOW.md)
- [Jenkins Setup](jenkins/setup-guide.md)
- [Slack Integration](docs/SLACK_INTEGRATION.md)
- [Splunk Integration](docs/SPLUNK_INTEGRATION.md)
- [Prometheus & Grafana](monitoring/prometheus-setup.md)

---

## 👨‍💻 Author

Built as a DevSecOps capstone project demonstrating end-to-end CI/CD pipeline with security, monitoring, and observability.
