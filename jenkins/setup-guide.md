# Jenkins Setup Guide

## 1. Launch EC2 Instance
- **Instance Type:** t2.large   
- **Storage:** 30 GB EBS  
- **Security Group:** Open ports 8080 (Jenkins), 9000 (SonarQube), 3000 (App) or allow all tarffic

---

## 2. Install Jenkins

```bash
sudo yum  install openjdk-17-jdk -y

# Add Jenkins repo
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo yum  install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

Access Jenkins: `http://<EC2-PUBLIC-IP>:8080`

---

## 3. Install Docker

```bash
sudo yum  install docker.io -y
sudo systemctl start docker
sudo chmod 777 /var/run/docker.sock
sudo systemctl restart docker
```

---

## 4. Run SonarQube Container

```bash
docker run -itd --name sonar -p 9000:9000 sonarqube:lts-community
```

Access SonarQube: `http://<EC2-PUBLIC-IP>:9000`  
Default credentials: `admin / admin`

---

## 5. Required Jenkins Plugins

Install from **Manage Jenkins → Plugins → Available plugins**:

| Plugin | Purpose |
|--------|---------|
| Eclipse Temurin Installer | JDK auto-install |
| SonarQube Scanner | SonarQube integration |
| NodeJs Plugin | Node.js tool |
| OWASP Dependency-Check | Vulnerability scanning |
| Docker Pipeline | Docker build/push in pipeline |
| Slack Notification | Slack alerts |
| Splunk | Build log forwarding |

---

## 6. Global Tool Configuration

**Manage Jenkins → Tools:**

| Tool | Name | Version |
|------|------|---------|
| JDK | `jdk17` | jdk-17.0.8.1+1 |
| NodeJS | `node16` | NodeJs 16.2.0 |
| SonarQube Scanner | `mysonar` | latest version |
| Dependency-Check | `Dp-Check` | latest version |

---

## 7. Configure SonarQube in Jenkins

1. In SonarQube: **Administration → Security → Users → Create Token** — copy the token
2. In Jenkins: **Manage Jenkins → Credentials → Add** → Secret Text → paste token → ID: `sonar-token`
3. In Jenkins: **Manage Jenkins → System → SonarQube servers:**
   - Name: `mysonar`
   - URL: `http://<EC2-IP>:9000`
   - Token: select `sonar-token`


---

## 8. DockerHub Credentials

**Manage Jenkins → Credentials → Add:**
- Kind: Username with password
- Username: your DockerHub username
- Password: your DockerHub password / access token
- ID: `docker-password`

---

## 9. Create Pipeline Job

1. **New Item** → Pipeline → name it `Tetrics-v1`
2. In **Pipeline** section: select **Pipeline script from SCM**
3. SCM: Git → Repository URL: `https://github.com/YOUR_USERNAME/devsecops-tetris.git`
4. Branch: `*/main`
5. Script Path: `Jenkinsfile`
6. **Save** → **Build Now**
