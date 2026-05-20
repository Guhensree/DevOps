# AIRMAN Production Readiness Project

Welcome to the AIRMAN Production Readiness Project. This repository hosts the infrastructure, CI/CD pipeline, and the core Node.js application for the Airman Audit API. Our goal is to maintain a scalable, secure, and observable system capable of high-throughput audit event ingestion.

## 🏗️ System Design

The architecture is built across three primary tiers:

1. **Application (Node.js API)**
   - A lightweight, performant Express server running on Node 20.
   - Containerized using Docker for deterministic, environment-agnostic deployments.
   - Exposes a robust `POST /audit` endpoint for event ingestion.

2. **Infrastructure (Terraform & AWS)**
   - **VPC & Networking:** A core VPC (10.0.0.0/16) segmented into public and private subnets across multiple Availability Zones.
   - **Compute:** EC2 instances deployed securely within private subnets to run the Dockerized API.
   - **Infrastructure as Code (IaC):** fully parameterized via Terraform to seamlessly support `dev`, `staging`, and `prod` environments.

3. **CI/CD (GitHub Actions)**
   - **Automated Pipelines:** Code is continuously tested, scanned for vulnerabilities, and built into Docker images tagged with the Git SHA.
   - **Mock Deployments:** Environment-aware deployment scripts map branches directly to target environments (`main` -> `prod`, `staging` -> `staging`).

## 🚀 Local Setup

To run the Audit API locally, ensure you have Node.js 20 and Docker installed.

### Running with Node.js
1. Install dependencies:
   ```bash
   npm install
   ```
2. Start the server:
   ```bash
   npm start
   ```
   The API will be available at `http://localhost:3000`.

### Running with Docker
1. Build the image:
   ```bash
   docker build -t airman-audit-api .
   ```
2. Run the container:
   ```bash
   docker run -p 3000:3000 airman-audit-api
   ```

## 🔭 Observability Strategy

To ensure high availability and rapid incident response, our observability stack includes:

- **Structured Logging:** All application logs are output in a structured JSON format to allow easy querying and ingestion.
- **Metrics (Datadog/Prometheus):** Core metrics (CPU, Memory, Request Rate, Error Rate, and Latency) are instrumented and exported to Datadog/Prometheus for real-time dashboards.
- **Alerting (PagerDuty):** Critical anomalies (e.g., 5xx error spikes, high latency) trigger automated alerts routed directly to the on-call engineer via PagerDuty.

## 🔐 Security Management

Security is treated as a first-class citizen across all layers of the stack:

- **Secrets Management:** Sensitive information (database credentials, API keys) is never hardcoded. We utilize AWS Secrets Manager to inject secrets dynamically at runtime.
- **IAM Least-Privilege:** AWS IAM roles are strictly scoped. For example, our EC2 instances only possess the exact permissions required to write to CloudWatch Logs (`logs:CreateLogGroup`, `logs:CreateLogStream`, `logs:PutLogEvents`).
- **Dependency Scanning:** The CI/CD pipeline enforces `npm audit --audit-level=high` to block deployments containing critical vulnerabilities.

---
*For incident response guidelines, please refer to the [RUNBOOK.md](./RUNBOOK.md).*
