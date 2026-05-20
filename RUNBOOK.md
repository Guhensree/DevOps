# AIRMAN Incident Readiness Runbook

This document serves as the primary operational guide for diagnosing, mitigating, and resolving incidents within the AIRMAN infrastructure.

---

## 1. What happens if a deployment fails?

**Symptom:** GitHub Actions pipeline fails during the `deploy` step, or infrastructure enters a degraded state post-deployment.

**Action Plan:**
1. **Investigate Logs:** Navigate to the failed GitHub Actions run to identify if the failure was in the test, build, or deploy phase. 
2. **Terraform Failures:** If `terraform apply` fails, inspect the state locks. If necessary, run `terraform plan` locally against the targeted workspace to identify configuration drifts. Do not manually modify infrastructure.
3. **Container/Startup Failures:** If the deployment succeeds but the application crashes on boot, check the CloudWatch logs for the newly deployed instances to identify configuration errors or missing environment variables.
4. **Resolution:** If the issue cannot be resolved in under 5 minutes, initiate an immediate rollback to the previous stable release.

---

## 2. What happens if latency spikes?

**Symptom:** PagerDuty alerts fire due to p99 API response times exceeding SLA thresholds (e.g., > 500ms).

**Action Plan:**
1. **Identify the Bottleneck:** Check Datadog/Prometheus dashboards to isolate whether the latency is in compute (CPU/Memory exhaustion) or downstream dependencies (Database, external APIs).
2. **Scaling Mitigation:** If compute is exhausted due to high traffic, temporarily scale up the Auto Scaling Group (ASG) minimum instances.
3. **Application Profiling:** Review structured logs for slow queries or specific endpoints causing the drag.
4. **Network/Infrastructure:** Verify that AWS network routing or NAT Gateways in the private subnets are not experiencing throttling.

---

## 3. What happens if the database becomes slow or unavailable?

**Symptom:** API endpoints return `503 Service Unavailable` or `504 Gateway Timeout`. Database connection metrics show drops or latency spikes.

**Action Plan:**
1. **Confirm Status:** Check the AWS RDS console for the database status. Is it modifying, rebooting, or experiencing a failover?
2. **Check Resource Utilization:** Look at Database CPU, Memory, and IOPS metrics. If IOPS burst credits are exhausted, consider scaling storage or migrating to Provisioned IOPS.
3. **Query Optimization:** If resources are normal but queries are slow, check the slow query log to identify unindexed lookups or locked tables.
4. **Failover Execution:** In the event of a total outage in the primary AZ, manually promote the read replica or wait for the automatic multi-AZ failover to complete. Notify stakeholders of read-only modes if applicable.

---

## 4. How do you rollback safely using the git SHA docker image tags?

**Symptom:** A newly deployed version introduces critical bugs or downtime, requiring a reversion to the previous stable state.

**Action Plan:**
Because our CI pipeline explicitly tags all Docker images with the exact Git commit SHA (`guhensree/airman-audit-api:${{github.sha}}`), rollbacks are fast and deterministic.

1. **Identify the Last Known Good SHA:** Check the GitHub commit history or the Docker Hub registry for the previous successful deployment SHA.
2. **Revert via Git:**
   - Execute a `git revert` of the problematic commit or merge request on the `main` branch.
   - Pushing the revert will automatically trigger the CI/CD pipeline, building a new image and deploying the stable code forward.
3. **Emergency Manual Rollback:** If the pipeline is down, manually update the deployment configuration (e.g., EC2 user data, ECS task definition, or Kubernetes deployment) to point to the previous Docker tag:
   ```bash
   # Example image reference
   guhensree/airman-audit-api:<PREVIOUS_STABLE_SHA>
   ```
4. **Verify:** Confirm application stability via monitoring dashboards and structured logs after the rollback completes.
