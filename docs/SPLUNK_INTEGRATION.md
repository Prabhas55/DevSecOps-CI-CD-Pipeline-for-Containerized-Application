# Jenkins + Splunk Integration Guide

## Overview

Splunk collects Jenkins build logs and displays them in a **Build Analysis** dashboard showing job name, build number, start time, duration, and status.

---

## Step 1 — Launch Splunk EC2 Instance

- **Type:** t2.medium  
- **Storage:** 25 GB EBS  
- **Port:** 8000 (Splunk UI), 8088 (HTTP Event Collector)

---

## Step 2 — Install Splunk

```bash
cd /opt/
wget -O splunk-9.0.1-Linux-x86_64.tgz \
  "https://download.splunk.com/products/splunk/releases/9.0.1/linux/splunk-9.0.1-82c987350fde-Linux-x86_64.tgz"

tar -zxvf splunk-9.0.1-Linux-x86_64.tgz
cd splunk/bin/
sudo ./splunk start --accept-license
```

Access Splunk: `http://<SPLUNK-IP>:8000`

---

## Step 3 — Install Splunk App for Jenkins

1. In Splunk dashboard: **Apps → Find More Apps**
2. Search for **Jenkins**
3. Install **Splunk App for Jenkins**
4. Log in with your Splunk.com credentials if prompted

---

## Step 4 — Create HTTP Event Collector Token

1. **Settings → Data Inputs → HTTP Event Collector**
2. Click **Global Settings:**
   - All Tokens: **Enabled**
   - Enable SSL: **Unchecked**
   - HTTP Port: `8088`
   - Save
3. Click **New Token:**
   - Name: `Jenkins`
   - Click **Next → Review → Submit**
4. Copy the generated **Token Value**

---

## Step 5 — Install Splunk Plugin in Jenkins

1. **Manage Jenkins → Plugins → Available plugins** → search `Splunk` → Install
2. **Manage Jenkins → System → Splunk:**

| Field | Value |
|-------|-------|
| Enable | ✅ Checked |
| HTTP Input Host | `<SPLUNK-PUBLIC-IP>` |
| HTTP Input Port | `8088` |
| HTTP Input Token | `<token from Step 4>` |
| SSL Enabled | Unchecked |
| Send All Pipeline Console Logs | ✅ Checked |
| Jenkins Master Hostname | `<JENKINS-PUBLIC-IP>` |

3. Click **Save** / **Apply**

---

## Step 6 — Restart Splunk

```bash
# In Splunk: Settings → Server Controls → Restart Splunk
```

---

## Result

The **Build Analysis** dashboard in Splunk shows:

| Jenkins Master | Job | Build | StartTime | Duration | Status |
|---------------|-----|-------|-----------|----------|--------|
| 43.204.22.210 | Tetrics-v1 | 9 | 2026-05-06 09:24:38 | 00:03:29.2 | ✅ |
| 43.204.22.210 | Tetrics-v1 | 8 | 2026-05-06 09:19:24 | 00:03:53.9 | ❌ |
| 43.204.22.210 | Tetrics-v1 | 7 | 2026-05-06 09:08:57 | 00:05:19.3 | ✅ |
