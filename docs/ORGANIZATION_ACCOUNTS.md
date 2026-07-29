# AkreTrix AWS Organization Accounts & Functions

This document specifies the exact architecture, ownership, and operational functions for each AWS account within the **AkreTrix** organization IaC framework.

---

## Accounts Matrix

| Account Name | Account ID | Email | Environment | Primary IaC Function |
|--------------|------------|-------|-------------|----------------------|
| **Account Management** | `128117030885` | `adminakretrix@gmail.com` | `management` | AWS Organization Master, SCPs, Consolidated Billing, Identity Center |
| **Deployment** | `830122794572` | `adminakretrix+awsdeployment@gmail.com` | `deployment` | Terragrunt Remote State Storage, CI/CD Roles, ECR, Shared Automation |
| **Production** | `126517272255` | `adminakretrix+awsproduction@gmail.com` | `prod` / `production` | Live Production Application Workloads (Landing Page, MonitoringSentinel APIs) |
| **nonproduction** | `568529364684` | `adminakretrix+awsnonproduction@gmail.com` | `dev` / `staging` | Dev, QA, and Staging Testing Environment for Workloads |
| **Audit** | `610849077178` | `adminakretrix+awsaudith@gmail.com` | `audit` | Security Governance, AWS Config, SecurityHub, GuardDuty, Compliance |
| **LogArchive** | `534283254869` | `adminakretrix+awslogarchive@gmail.com` | `logarchive` | Central Immutable Log Vault (CloudTrail, VPC Flow Logs, CloudWatch Logs) |
| **Backups** | `873310977008` | `adminakretrix+awsbackups@gmail.com` | `backups` | Central AWS Backup Vaults, Cross-Account Snapshot Replication & DR |

---

## Detailed Functions & IaC Roles

### 1. Account Management (`128117030885`)
- **Primary Function**: AWS Organization Root & Identity Management.
- **IaC Responsibilities**:
  - AWS Organizations structure (Organizational Units / OUs).
  - Service Control Policies (SCPs) enforcing regional bounds (`us-east-1` restriction).
  - Consolidated Billing and AWS Cost Explorer / Budget alerts.
  - AWS IAM Identity Center (SSO) integration for admin access.
- *Note*: No application workload resources should ever be deployed in this account.

### 2. Deployment (`830122794572`)
- **Primary Function**: DevOps, CI/CD Engine & Remote State Host.
- **IaC Responsibilities**:
  - **Terragrunt S3 State Storage**: Central bucket `akretrix-terragrunt-state-830122794572-us-east-1` with S3 versioning, AES256 encryption, and native lockfiles.
  - **GitHub Actions OIDC Provider**: `token.actions.githubusercontent.com` IAM OpenID Connect federation.
  - **CI/CD IAM Roles**: Cross-account role assumptions for GitHub Actions workflows (`akretrix-landing-page`, `monitoringsentinel`, `akretrix-iac`).
  - **Shared Container Registry**: Amazon ECR repositories for containerized services.

### 3. Production (`126517272255`)
- **Primary Function**: Live Customer-Facing Production Workloads.
- **IaC Responsibilities**:
  - **Landing Page Frontend**: S3 static bucket (`akretrix-landing-page-prod-static`) + CloudFront CDN + Origin Access Control (OAC).
  - **Free Tools Backend API**: `akretrix-free-tools-api` Lambda function and Function URL / API Gateway.
  - **MonitoringSentinel Production Core**: HTTP API Gateway, Lambda execution roles, CloudWatch log groups, and production database / cache stores.
  - Production SSL/TLS Certificates (ACM) and Route53 DNS records for `akretrix.com`.

### 4. nonproduction (`568529364684`)
- **Primary Function**: Development, Testing, and Staging Workloads.
- **IaC Responsibilities**:
  - Dev/Staging mirror of production infrastructure for pre-release testing.
  - Dev Landing Page S3 + CloudFront static distribution (`akretrix-landing-page-dev-static`).
  - Dev MonitoringSentinel API Gateway and Lambda functions.
  - Enables developers to safely run `terragrunt apply` in `aws/dev/us-east-1` without impacting live customers.

### 5. Audit (`610849077178`)
- **Primary Function**: Security Governance, IAM Auditing & Compliance.
- **IaC Responsibilities**:
  - AWS SecurityHub master administration.
  - Amazon GuardDuty threat detection aggregation.
  - AWS Config rules and conformance packs for CIS AWS Foundations Benchmark compliance.
  - IAM Access Analyzer and central security alert notifications.

### 6. LogArchive (`534283254869`)
- **Primary Function**: Centralized, Immutable Security & Audit Log Storage.
- **IaC Responsibilities**:
  - Organization-wide AWS CloudTrail S3 destination bucket.
  - Central S3 buckets receiving VPC Flow Logs and CloudWatch logs from Production and Non-Production accounts.
  - S3 Object Lock and lifecycle retention rules enforcing retention policies.

### 7. Backups (`873310977008`)
- **Primary Function**: Disaster Recovery & Cross-Account Backup Storage.
- **IaC Responsibilities**:
  - Central AWS Backup Vault with AWS KMS encryption.
  - Cross-account backup copy policies for RDS snapshots, DynamoDB tables, and S3 bucket backups from Production.
  - Disaster Recovery (DR) automation procedures.
