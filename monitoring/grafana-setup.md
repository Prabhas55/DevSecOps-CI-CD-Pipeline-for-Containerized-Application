# Grafana Setup on Kubernetes

## 1. Create Grafana Namespace & Install

```bash
kubectl create namespace grafana

helm repo add grafana https://grafana.github.io/helm-charts

helm install grafana grafana/grafana \
    --namespace grafana \
    --set persistence.storageClassName="gp2" \
    --set persistence.enabled=true \
    --set adminPassword='EKS!sAWSome' \
    --set service.type=LoadBalancer

# Get pods
kubectl get pods -n grafana

# Get LoadBalancer URL
kubectl get service -n grafana
```

Access Grafana at the **EXTERNAL-IP** shown in the service output.

**Login:** `admin` / `EKS!sAWSome`

---

## 2. Add Prometheus as Data Source

1. Go to **Connections → Data sources → Add new data source**
2. Select **Prometheus**
3. In **Connection URL**, enter:
   ```
   http://prometheus-server.prometheus.svc.cluster.local
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

## 5. Loki + Promtail (Log Aggregation)

```bash
mkdir grafana_configs
cd grafana_configs

wget https://raw.githubusercontent.com/grafana/loki/v2.8.0/cmd/loki/loki-local-config.yaml -O loki-config.yaml
wget https://raw.githubusercontent.com/grafana/loki/v2.8.0/clients/cmd/promtail/promtail-docker-config.yaml -O promtail-config.yaml

# Run Loki
sudo docker run -d --name loki \
    -v $(pwd):/mnt/config \
    -p 3100:3100 \
    grafana/loki:2.8.0 \
    --config.file=/mnt/config/loki-config.yaml

# Run Promtail
sudo docker run -d --name promtail \
    -v $(pwd):/mnt/config \
    -v /var/log:/var/log \
    --link loki \
    grafana/promtail:2.8.0 \
    --config.file=/mnt/config/promtail-config.yaml
```
