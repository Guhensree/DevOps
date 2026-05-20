# AIRMAN Production Readiness Project

Welcome to the **AIRMAN Production Readiness Project**. This repository contains the source code, infrastructure as code, and deployment automation for the AIRMAN Audit Event API, engineered for high availability, security, and operational excellence in a multi-tier AWS environment.

## 🚀 System Design

The architecture is built with a focus on scalability and automation, segmented into three core pillars:

- **Node.js API**: A lightweight, high-performance Express server acting as the ingress for audit events, optimized for quick execution and low resource consumption.
- **Terraform AWS Infrastructure**: A scalable multi-tier architecture deployed on AWS. It provisions a custom VPC, distributed public and private subnets, and manages strict IAM least-privilege roles for compute instances.
- **GitHub Actions CI/CD**: A fully automated pipeline ensuring code quality and seamless delivery. It handles testing, dependency auditing, Docker image containerization, and environment-aware deployments to Dev, Staging, and Production.

## 🛡️ Security Management

Security is a primary consideration throughout the application lifecycle:
- **IAM Least-Privilege**: AWS resources (like EC2) are assigned strict IAM roles that only permit exact required actions (e.g., specific CloudWatch write operations).
- **Secrets Management**: Sensitive configuration and credentials are out-of-band and securely injected via AWS Secrets Manager and GitHub Secrets (`DOCKER_PASSWORD`).
- **Dependency Auditing**: The CI/CD pipeline enforces `npm audit --audit-level=high` to block deployments introducing critical vulnerabilities.

## 📊 Observability Strategy

We maintain deep visibility into the application health to ensure rapid incident response:
- **Structured Logging**: The Node.js application outputs JSON-formatted, structured logs for easy ingestion and querying.
- **Metrics (Datadog/Prometheus)**: Telemetry data, system resource utilization, and application-specific metrics are exported and monitored.
- **Alerting (PagerDuty)**: Anomalies, downtime, and breached thresholds automatically trigger actionable alerts routed to the on-call engineers via PagerDuty.

## 💻 Local Setup Instructions

Follow these steps to get the API running on your local machine.

### Prerequisites
- Node.js v20+
- Docker & Docker Compose
- Terraform (for infrastructure work)

### Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/Guhensree/DevOps.git
   cd DevOps
   ```
2. **Install dependencies:**
   ```bash
   npm install
   ```
3. **Start the API:**
   ```bash
   npm start
   ```
   The API will be available at `http://localhost:3000`.

### Running in Docker
To build and run the Dockerized version locally:
```bash
docker build -t airman-audit-api:local .
docker run -p 3000:3000 airman-audit-api:local
```
