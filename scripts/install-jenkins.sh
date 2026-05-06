#!/bin/bash
# ============================================================
# Jenkins + Docker + Git + Java Install Script
# Run as: chmod +x install-jenkins.sh && ./install-jenkins.sh
# ============================================================

set -e

echo "==> Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "==> Installing Java 17..."
sudo apt install openjdk-17-jdk -y
java -version

echo "==> Installing Git..."
sudo apt install git -y

echo "==> Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "==> Installing Docker..."
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu
sudo chmod 777 /var/run/docker.sock
sudo systemctl restart docker

echo ""
echo "============================================"
echo " Jenkins is running at: http://$(curl -s ifconfig.me):8080"
echo " Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "============================================"
