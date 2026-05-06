# Prometheus Setup on Kubernetes (KOPS)

## 1. Install Helm (if not already done)

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm version
```

## 2. Install Kubernetes Metrics Server

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl get pods -n kube-system
kubectl get deployment metrics-server -n kube-system
```

## 3. Add Prometheus Helm Repo

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm repo list
```

## 4. Create Prometheus Namespace & Install

```bash
kubectl create namespace prometheus

helm install prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="gp2" \
    --set server.persistentVolume.storageClass="gp2"

# Verify
kubectl get pods -n prometheus
kubectl get all -n prometheus
```

## 5. Access Prometheus (port-forward for local testing)

```bash
kubectl port-forward -n prometheus svc/prometheus-server 9090:80
# Open: http://localhost:9090
```

---

## Dashboard IDs to Import in Grafana

| Dashboard ID | Description |
|-------------|-------------|
| `6417` | Kubernetes Cluster (Prometheus) |
| `315` | Network I/O, CPU, Memory, Filesystem |
| `1860` | Node Exporter Full (per-node metrics) |

---

## Metrics Monitored

- Network I/O pressure
- Cluster CPU usage (1m avg)
- Cluster memory usage
- Cluster filesystem usage
- Pods CPU usage
- Individual node metrics
