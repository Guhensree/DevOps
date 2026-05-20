# AIRMAN - Production Readiness Automation

## Overview
This repository contains a minimal backend service for ingesting application audit events, packaged and automated with production-grade DevOps practices. It focuses on operational safety, CI/CD automation, and Infrastructure as Code.

## Quick Start (Local Setup)
1. **Install dependencies:** `npm install`
2. **Set configuration:** Create a `.env` file and set `PORT=3000`.
3. **Run locally:** `node index.js`
4. **Run via Docker:** * `docker build -t airman-audit-api .`
   * `docker run -p 3000:3000 -d airman-audit-api`

## System Design
* **Backend:** Lightweight Node.js/Express API to minimize overhead.
* **Infrastructure:** AWS (VPC, Subnets, IAM) parameterized via Terraform for clear dev/staging/prod environments.
* **CI/CD:** GitHub Actions pipeline that enforces tests, runs security audits, builds immutable Docker images, and executes branch-based deployments.

## Observability Strategy
* **Logging:** In a full production rollout, `console.log` is replaced by a structured JSON logger (like Winston/Pino) shipping logs to CloudWatch or ELK.
* **Metrics & Dashboards:** System metrics (CPU/Memory) and APM metrics (Request Latency, Error Rate) are tracked via Datadog or Prometheus/Grafana.
* **Alerting:** Critical thresholds (e.g., 5xx errors > 1% over 5 mins) route to PagerDuty to page the on-call engineer.

## Security & Secrets Management
* **Secrets:** No hardcoded secrets exist in the repository. Production secrets (like DB passwords) are injected at runtime via AWS Secrets Manager. CI/CD secrets (Docker Hub credentials) use GitHub Actions Encrypted Secrets.
* **Scanning:** The CI/CD pipeline enforces `npm audit` on every PR to block vulnerable dependencies from being merged.
* **IAM:** Terraform provisions least-privilege roles, restricting the compute environment to only the permissions it explicitly needs (e.g., writing logs).
