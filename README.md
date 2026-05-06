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
├── Jenkinsfile                          # Main CI/CD pipeline
├── jenkins/
│   └── setup-guide.md                   # Jenkins setup instructions
├── k8s/
│   ├── deployment.yml                   # Kubernetes Deployment
│   └── service.yml                      # Kubernetes Service (LoadBalancer)
├── monitoring/
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


<img width="1918" height="1078" alt="jenkins dash" src="https://github.com/user-attachments/assets/b784a581-8096-43a5-b0f1-28056082a391" />
<img width="1918" height="1078" alt="jenkins" src="https://github.com/user-attachments/assets/9db26c10-651c-43b9-aa43-255c3a74a981" />
<img width="1918" height="1078" alt="sonar1" src="https://github.com/user-attachments/assets/41a99858-351a-4bde-9c24-4134ac23fdfd" />
<img width="1917" height="1078" alt="splunk" src="https://github.com/user-attachments/assets/3f7ec0ff-05d7-42b6-a43d-fc76e5bf7f76" />
<img width="1918" height="1078" alt="slack" src="https://github.com/user-attachments/assets/9be60fd1-2abd-4c25-b63c-9504cc115fbf" />

<img width="1918" height="1078" alt="kops" src="https://github.com/user-attachments/assets/3f1c28aa-f20f-4a18-a88b-9ee65085a246" /
<img width="1917" height="1078" alt="argov2" src="https://github.com/user-attachments/assets/a3c5d42a-e02e-49c3-9afa-9cf6cdde8ab3" />
<img width="1918" height="1078" alt="server" src="https://github.com/user-attachments/assets/d0709a15-783a-4a58-a813-f70b5bff95a1" />
<img width="1918" height="1078" alt="garfana" src="https://github.com/user-attachments/assets/1942cbb6-a2e9-415e-b7af-f9333b027e6a" />


SCREENSHOTS OF BOTH VERSIONS:
<img width="1918" height="1078" alt="out1" src="https://github.com/user-attachments/assets/7c2fe7e4-5482-4318-bca4-4ace2c441289" />
<img width="1918" height="1078" alt="out2" src="https://github.com/user-attachments/assets/51bd8797-b6a7-4d85-b398-2f8e21fecc86" />





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
