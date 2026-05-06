#!/bin/bash
# ============================================================
# Trivy Installation Script
# ============================================================

echo "==> Installing Trivy..."

wget https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.tar.gz
tar zxvf trivy_0.18.3_Linux-64bit.tar.gz
sudo mv trivy /usr/local/bin/

# Add to PATH
Vim .bashrc
echo 'export PATH=$PATH:/usr/local/bin/' >> ~/.bashrc
source .bashrc

echo ""
trivy --version
echo "==> Trivy installed successfully!"
