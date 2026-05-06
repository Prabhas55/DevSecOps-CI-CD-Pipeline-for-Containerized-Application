#!/bin/bash
# ============================================================
# KOPS Kubernetes Cluster Setup on AWS
# Prerequisites: AWS CLI configured, Route53 domain or S3 bucket
# ============================================================

set -e

# ── Configuration — edit these ──────────────────────────────
CLUSTER_NAME="devops.k8s.local"
KOPS_STATE_STORE="s3://your-kops-state-store-bucket"
AWS_REGION="ap-south-1"
NODE_COUNT=2
NODE_SIZE="t3.medium"
MASTER_SIZE="c5a.xlarge"
ZONES="${AWS_REGION}a"

echo "==> Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "==> Installing KOPS..."
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/

echo "==> Installing Helm..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm version

echo "==> Creating S3 bucket for KOPS state..."
aws s3 mb $KOPS_STATE_STORE --region $AWS_REGION || true
aws s3api put-bucket-versioning \
    --bucket $(echo $KOPS_STATE_STORE | sed 's|s3://||') \
    --versioning-configuration Status=Enabled

echo "==> Creating KOPS cluster..."
export KOPS_STATE_STORE=$KOPS_STATE_STORE

kops create cluster \
    --name=$CLUSTER_NAME \
    --state=$KOPS_STATE_STORE \
    --zones=$ZONES \
    --node-count=$NODE_COUNT \
    --node-size=$NODE_SIZE \
    --master-size=$MASTER_SIZE \
    --dns-zone=$CLUSTER_NAME \
    --yes

echo "==> Validating cluster (this may take 10-15 minutes)..."
kops validate cluster --wait 15m

echo "==> Cluster is ready!"
kubectl get nodes

echo ""
echo "==> Installing Metrics Server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo ""
echo "============================================"
echo " Cluster: $CLUSTER_NAME"
echo " Nodes: $(kubectl get nodes --no-headers | wc -l)"
echo "============================================"
