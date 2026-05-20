# AIRMAN Incident Readiness Runbook

This runbook outlines the standard operating procedures for responding to critical incidents within the AIRMAN Audit API ecosystem.

## 🚨 Scenarios & Playbooks

### 1. What happens if a deployment fails?
**Symptom:** GitHub Actions pipeline fails during the `build-and-containerize` or `deploy` stage, or the application fails to start post-deployment.

**Action Plan:**
1. **Investigate:** Check the GitHub Actions logs to determine the point of failure (e.g., failed `npm audit`, Docker build error, Terraform apply failure).
2. **Review Infrastructure:** If Terraform failed, verify the AWS console for resource quotas or permission issues. DO NOT manually modify state.
3. **Rollback (if necessary):** If a bad state was partially deployed, revert the merge commit in GitHub to trigger a fresh, stable deployment pipeline from the previous good state.
4. **Post-Mortem:** Document the failure reason and implement a fix to prevent recurrence.

### 2. What happens if latency spikes?
**Symptom:** PagerDuty alerts fire due to P99 latency exceeding acceptable thresholds (e.g., > 500ms) on the `/audit` endpoint.

**Action Plan:**
1. **Analyze Metrics:** Open the Datadog/Prometheus dashboards. Correlate the latency spike with other metrics like CPU utilization, Memory usage, or network I/O on the EC2 instances.
2. **Check Logs:** Query the structured logs in CloudWatch/Datadog to identify if specific payloads or downstream dependencies are causing the bottleneck.
3. **Scale Capacity:** If the spike is due to legitimate high traffic (DDoS ruled out), horizontally scale the infrastructure by increasing the desired count in the Auto Scaling Group via Terraform.
4. **Isolate:** If a specific new feature caused the spike, consider rolling back to the previous Git SHA.

### 3. What happens if the database becomes slow or unavailable?
**Symptom:** The API starts throwing 5xx errors or timing out when attempting to persist audit events, triggering PagerDuty alerts.

**Action Plan:**
1. **Verify DB Health:** Check the RDS/Database monitoring dashboard for high CPU, memory exhaustion, or storage limits.
2. **Check Connections:** Ensure the API isn't exhausting the database connection pool. Look for "Too many connections" errors in the API logs.
3. **Failover (if applicable):** If the primary database instance is degraded, initiate a manual failover to the standby replica (if automated failover hasn't already occurred).
4. **Mitigate Data Loss:** If the database is completely unreachable, ensure the API is failing gracefully. Depending on business requirements, consider temporarily queuing events to an SQS dead-letter queue or falling back to flat-file logging until the database is restored.

### 4. How do you rollback safely using the Git SHA Docker image tags?
**Symptom:** A deployed version contains critical bugs or performance regressions, and you need to immediately revert to the last stable version.

**Action Plan:**
Our CI/CD pipeline tags every Docker image with the specific Git SHA (`guhensree/airman-audit-api:${{github.sha}}`), making rollbacks precise and deterministic.

**Steps to Rollback:**
1. **Identify the Good SHA:** Find the Git SHA of the last known stable commit from the GitHub commit history or the successful GitHub Actions run.
2. **Revert in Git:** The preferred and safest method is to use Git to revert the problematic commit.
   ```bash
   git revert <bad-commit-sha>
   git push origin main
   ```
   *This will automatically trigger the CI/CD pipeline to build and deploy a new image that perfectly matches the old, stable state.*
3. **Emergency Manual Rollback (Break-Glass):** If CI/CD is down, you can manually update the deployment configuration (e.g., in Terraform or the ECS/EKS task definition) to point directly to the old Docker image tag:
   - Change `image: guhensree/airman-audit-api:<bad-sha>` to `image: guhensree/airman-audit-api:<good-sha>`.
   - Apply the changes to the infrastructure.
