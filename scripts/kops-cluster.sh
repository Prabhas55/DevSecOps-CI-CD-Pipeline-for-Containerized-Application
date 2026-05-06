#!/bin/bash
# ============================================================
# KOPS Kubernetes Cluster Setup on AWS
# Prerequisites: AWS CLI configured, Route53 domain or S3 bucket
# ============================================================

CREATE IAM ROLE WITH ADMIN PERMISSIONS AND ATTACH IT TO OUR INSTANCE,
	SELECT INSTANCE >>> ACTIONS >>> SECURITY >>>> MODIFY IAM ROLE


# ── Configuration — edit these ──────────────────────────────
CLUSTER_NAME="devops.k8s.local"
AWS_REGION="ap-south-1"
NODE_COUNT=2
NODE_SIZE="t3.medium"
MASTER_SIZE="c5a.xlarge"
ZONES="${AWS_REGION}a"

echo "==> Installing Helm..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm version

echo "==> Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "==> Installing KOPS..."
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/



echo "==> Creating S3 bucket for KOPS state..."
TO CREATE BUCKET: aws s3api create-bucket --bucket "bucket name" --region $AWS_REGION
		TO ENABLE VERSION: aws s3api put-bucket-versioning --bucket "bucket name" --region $AWS_REGION --versioning-configuration Status=Enabled
		EXPORT CLUSTER DATA INTO BUCKET: export KOPS_STATE_STORE=s3://bucket name


echo "==> Creating KOPS cluster..."
EXPORT CLUSTER DATA INTO BUCKET: export KOPS_STATE_STORE=s3://bucket name

kops create cluster \
    --name=$CLUSTER_NAME \
    --zones=$ZONES \
    --node-count=$NODE_COUNT \
    --node-size=$NODE_SIZE \
    --master-size=$MASTER_SIZE \
    --yes

kubectl get nodes

