# AIRMAN Incident Readiness Runbook

## 1. What happens if a deployment fails?
* **Detection:** The GitHub Actions pipeline will catch the failure during the `test-and-scan` or `deploy` job and trigger an alert (via Slack/Email integration).
* **Action:** The pipeline is configured to halt automatically, preventing the broken image from reaching production.
* **Resolution:** Inspect the CI/CD logs in GitHub Actions. If the failure occurred in a lower environment (dev/staging), block the promotion, fix the code locally, and push a new commit.

## 2. What happens if latency spikes?
* **Detection:** CloudWatch/Prometheus alerts will trigger when the P99 latency exceeds our defined SLO threshold (e.g., >500ms).
* **Action:** 1. Check the APM dashboard (e.g., Datadog/New Relic) to isolate the bottleneck (Compute vs. Database).
  2. If compute-bound, verify autoscaling rules are triggering. 
  3. If application-bound, inspect structured logs for slow queries or blocked event loops.

## 3. What happens if the database becomes slow or unavailable?
* **Detection:** Application will begin throwing 5xx errors; connection pool timeouts will appear in structured logs.
* **Action:** 1. **Unavailable:** If using RDS Multi-AZ, an automatic failover to the standby replica will occur. 
  2. **Slow:** Check database metrics (CPU, IOPS, active connections). If it's a sudden load spike, consider temporarily scaling up instance size or implementing an external cache (Redis) for read-heavy operations.

## 4. How do you rollback safely?
* **Action:** Our CI/CD tags every Docker image with its unique Git SHA. To roll back safely:
  1. Re-run the GitHub Actions deployment job of the *last known good commit*, or
  2. Update the Terraform/ECS task definition to point back to the previous stable Docker image tag and apply the state. This ensures a clean, immutable rollback rather than manually patching a live server.
