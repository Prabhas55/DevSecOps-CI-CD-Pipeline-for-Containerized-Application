#!/bin/bash
# ============================================================
# Jenkins + Docker + Git + Java Install Script
# Run as: chmod +x install-jenkins.sh && ./install-jenkins.sh
# ============================================================



sudo dnf install java-21-amazon-corretto -y

java -version

echo "==> Installing Git..."
yum  install git -y

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install jenkins -y
systemctl start jenkins
sudo systemctl enable jenkins

echo "==> Installing Docker..."
sudo yum install docker -y
sudo systemctl start docker
sudo chmod 777 /var/run/docker.sock
sudo systemctl restart docker

echo ""
echo "============================================"
echo " Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "============================================"
