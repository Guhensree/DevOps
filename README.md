# AIRMAN Production Readiness

Welcome to the AIRMAN Production Readiness project. This repository contains the source code for a highly available, secure, and observable Audit Event API, alongside its underlying cloud infrastructure and CI/CD deployment pipelines.

## Project Overview

The AIRMAN project is designed with production-grade reliability and security in mind, providing a robust ingestion endpoint for application audit events.

### System Design

The architecture is built on three core pillars:
- **Node.js API**: A lightweight, high-performance Express server for ingesting audit events. Containerized using a multi-stage Docker build for minimal footprint and deterministic dependency installation (`npm ci`).
- **AWS Infrastructure (Terraform)**: Infrastructure as Code (IaC) manages a secure, multi-tier AWS deployment. It provisions a Core VPC with public and private subnets across multiple availability zones to ensure high availability and network isolation.
- **CI/CD (GitHub Actions)**: An automated pipeline handles testing, security scanning, containerization, and environment-aware deployments across `dev`, `staging`, and `prod` environments.

### Observability Strategy

To ensure system health and rapid incident response, the project incorporates a comprehensive observability suite:
- **Structured Logging**: The application outputs JSON-formatted logs for easy ingestion and querying by central logging systems.
- **Metrics (Datadog/Prometheus)**: Key performance indicators (KPIs) such as request rate, error rate, and response duration are instrumented for real-time monitoring.
- **Alerting (PagerDuty)**: Critical thresholds trigger automated alerts routing to the on-call engineer, ensuring minimal downtime.

### Security Management

Security is treated as a first-class citizen at every layer:
- **AWS Secrets Manager**: Sensitive credentials and API keys are stored securely and injected at runtime, preventing hardcoded secrets.
- **IAM Least-Privilege**: AWS IAM roles (like the EC2 CloudWatch role) are narrowly scoped strictly to the permissions required to perform their function.
- **Vulnerability Scanning**: Automated `npm audit --audit-level=high` runs on every pull request and commit to prevent vulnerable dependencies from reaching production.

---

## Local Setup Instructions

Follow these steps to run the AIRMAN API locally:

### Prerequisites
- [Node.js](https://nodejs.org/) (v20+)
- [Docker](https://www.docker.com/) (optional, for containerized testing)
- [Terraform](https://www.terraform.io/) (optional, for infrastructure testing)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
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
   The API will be available at `http://localhost:3000/audit`.

### Docker (Local Testing)

To build and run the Docker image locally:
```bash
docker build -t airman-audit-api .
docker run -p 3000:3000 airman-audit-api
```
