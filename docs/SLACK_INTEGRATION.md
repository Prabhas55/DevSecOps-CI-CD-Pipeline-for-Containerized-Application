# Jenkins + Slack Integration Guide

## Overview

Jenkins sends build notifications (SUCCESS / FAILURE) to a Slack `#deployment` channel automatically after each pipeline run.

---

## Step 1 — Install Slack Plugin in Jenkins

**Manage Jenkins → Plugins → Available plugins** → search `Slack Notification` → Install

---

## Step 2 — Create Slack Workspace

1. Go to [slack.com](https://slack.com) → **Create a new workspace**
2. Name it (e.g. `Tetrics`)
3. Create a channel called `#deployment`

---

## Step 3 — Add Jenkins CI App to Slack

1. In Slack: **Profile → Tools & Settings → Manage Apps**
2. Search for **Jenkins CI** → **Add to Slack**
3. Select channel: `#deployment`
4. Click **Add Jenkins CI Integration**
5. Copy the **Team subdomain** and **Integration token** shown on the next page

---

## Step 4 — Configure Slack in Jenkins

**Manage Jenkins → System → Slack section:**

| Field | Value |
|-------|-------|
| Workspace | `your-slack-subdomain` (e.g. `tetrics-iyo3319`) |
| Credential | Add secret text → paste Slack token → ID: `slack-token` |
| Default channel | `#deployment` |

Click **Test Connection** → you should see "Success"

---

## Step 5 — Pipeline Post Block

Add this to your `Jenkinsfile` (already included):

```groovy
def COLOR_MAP = [
    'FAILURE' : 'danger',
    'SUCCESS' : 'good'
]

post {
    always {
        slackSend (
            channel: '#deployment',
            color: COLOR_MAP[currentBuild.currentResult],
            message: """*${currentBuild.currentResult}:* Job ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}
More info at: ${env.BUILD_URL}"""
        )
    }
}
```

---

## Result

After each build, the `#deployment` channel receives:

```
✅ SUCCESS: Job Tetrics-v1
Build Number: 9
More info at: http://43.204.22.210:8080/job/Tetrics-v1/9/

❌ FAILURE: Job Tetrics-v1
Build Number: 8
More info at: http://43.204.22.210:8080/job/Tetrics-v1/8/
```
