# Incident Readiness Runbook

This runbook outlines standard operating procedures and response strategies for common incidents affecting the AIRMAN Audit API.

---

## Scenario 1: What happens if a deployment fails?

**Symptoms:** GitHub Actions pipeline fails during the `deploy` job, or the application fails to boot in the target environment after a seemingly successful deployment.

**Response Steps:**
1. **Investigate Pipeline Logs:** Check the GitHub Actions logs to identify the exact point of failure (e.g., Terraform apply errors, Docker pull failures, or application crash loops).
2. **Halt Progression:** If the failure occurs in `staging`, block the promotion to `prod`.
3. **Inspect Infrastructure State:** If Terraform failed, verify the state lock and review the specific resource creation error.
4. **Immediate Rollback (if applicable):** If the deployment partially succeeded but introduced breaking application changes, immediately initiate the rollback procedure outlined in Scenario 4.

---

## Scenario 2: What happens if latency spikes?

**Symptoms:** PagerDuty alerts triggered by Datadog/Prometheus indicating P99 latency has exceeded acceptable SLAs (e.g., >500ms).

**Response Steps:**
1. **Acknowledge Alert:** Acknowledge the PagerDuty alert to prevent escalation.
2. **Analyze Metrics Dashboard:** Identify the source of the latency. Is it CPU/Memory exhaustion on the compute instances, or is it an external dependency (like a database or downstream API)?
3. **Scale Compute:** If compute resources are exhausted, manually scale out the Auto Scaling Group (ASG) or ECS service while investigating the root cause.
4. **Investigate Logs:** Query structured logs for specific endpoints causing delays or unusual errors during the spike window.

---

## Scenario 3: What happens if the database becomes slow or unavailable?

**Symptoms:** Application logs show frequent connection timeouts, query timeouts, or 500 Internal Server Errors originating from the database driver. PagerDuty alerts fire for high error rates.

**Response Steps:**
1. **Assess Database Health:** Check the RDS/Database console for CPU usage, memory, disk I/O, and active connections. 
2. **Failover Execution:** If the primary database instance is unresponsive, manually initiate a failover to the standby replica (if not automatically triggered by the managed service).
3. **Circuit Breaker/Rate Limiting:** If the database is overwhelmed by traffic, temporarily reduce incoming traffic by adjusting API Gateway rate limits or relying on application-level circuit breakers to return 503s gracefully.
4. **Query Analysis:** Once stabilized, analyze slow query logs to identify unoptimized queries or missing indexes causing the bottleneck.

---

## Scenario 4: How do you rollback safely using the git SHA docker image tags?

**Procedure:**
Because our CI/CD pipeline tags every Docker image with the unique Git commit SHA (`guhensree/airman-audit-api:${{ github.sha }}`), rolling back to a known good state is deterministic and fast.

1. **Identify the Last Known Good SHA:** Review the deployment history or Git log to find the SHA of the commit before the regression was introduced.
2. **Revert in Git (Preferred for permanent fix):**
   - Run `git revert <bad-commit-sha>` locally.
   - Push the revert commit to the branch.
   - The CI/CD pipeline will automatically build a new image (with a new SHA) containing the reverted code and deploy it forward.
3. **Emergency Manual Rollback (If CI/CD is down or immediate mitigation is required):**
   - Access the target environment (e.g., via ECS console or kubectl).
   - Manually update the task definition or deployment manifest to point to the previous working Docker image tag: `guhensree/airman-audit-api:<last-known-good-sha>`.
   - Force a redeployment of the service to apply the change immediately.
