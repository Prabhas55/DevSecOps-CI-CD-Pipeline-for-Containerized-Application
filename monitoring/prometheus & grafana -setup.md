# Grafana Setup on Kubernetes

# 1 .STEPS TO SETUP PROMETHEUS & GRAFANA IN KOPS:
# STEP 1:
INSTALL HEML:
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm version

# STEP 2:
INSTALL K8S METRICS SERVER:
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
Verify that the metrics-server deployment is running the desired number of pods 
kubectl get pods -n kube-system
kubectl get deployment metrics-server -n kube-system

# STEP 3:
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
UPDATE HELM CHART REPOS:
helm repo update
helm repo list

# STEP 4:
CREATE PROMETHEUS NAMESPACE:
kubectl create namespace prometheus
kubectl get ns

# STEP 5:
INSTALL PROMETHEUS:
helm install prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.storageClass="gp2" --set server.persistentVolume.storageClass="gp2"
kubectl get pods -n prometheus
kubectl get all -n prometheus

# STEP 6:
CREATE GRAFANA NAMESPACE:
kubectl create namespace grafana

# STEP 7
INSTALL GRAFANA:
helm install grafana grafana/grafana --namespace grafana --set persistence.storageClassName="gp2" --set persistence.enabled=true --set adminPassword='EKS!sAWSome' --set service.type=LoadBalancer
kubectl get pods -n grafana
kubectl get service -n grafana


**Copy the EXTERNAL-IP and paste in browser**


---

## 2. Add Prometheus as Data Source

1. Go to **Connections → Data sources → Add new data source**
2. Select **Prometheus**
3. In **Connection URL**, enter:
   ```
   http://prometheus-server.prometheus.svc.cluster.local(default)
   ```
4. Click **Save & Test** — you should see "Data source is working"

---

## 3. Import Kubernetes Dashboard

1. Go to **Dashboards → New → Import**
2. Enter dashboard ID: `6417` → Click **Load**
3. Select your Prometheus data source
4. Click **Import**

Repeat with:
- `315` — for Network I/O, CPU, Memory, Filesystem
- `1860` — for individual node metrics

---

## 4. What You'll See

From your live cluster (as shown in screenshots):

| Metric | Value |
|--------|-------|
| Cluster memory usage | ~37.1% |
| Cluster CPU usage (1m avg) | ~0.78% |
| Network I/O (received) | ~4.98 kB/s |
| Network I/O (sent) | ~-25.8 kB/s |

---

