# AkreTrix Infrastructure as Code (IaC)

Centralized Infrastructure as Code repository for the **AkreTrix** organization, built using [Terragrunt](https://terragrunt.gruntwork.io/) and [Terraform](https://www.terraform.io/).

## AWS Accounts Architecture

Detailed account descriptions and IaC functions are documented in [docs/ORGANIZATION_ACCOUNTS.md](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/docs/ORGANIZATION_ACCOUNTS.md).

| Account Name | Account ID | Email | Role / IaC Purpose | State Storage |
|--------------|------------|-------|--------------------|---------------|
| **Management** | `128117030885` | `adminakretrix@gmail.com` | AWS Organization Master, SCPs, SSO | N/A |
| **Deployment** | `830122794572` | `adminakretrix+awsdeployment@gmail.com` | CI/CD Roles, OIDC, Terragrunt S3 Remote State Host (`akretrix-terragrunt-state-830122794572-us-east-1`) | ✅ Host |
| **Production** | `126517272255` | `adminakretrix+awsproduction@gmail.com` | Live Production Workloads (`prod`) | Remote Target |
| **nonproduction** | `568529364684` | `adminakretrix+awsnonproduction@gmail.com` | Dev & Staging Workloads (`dev`) | Remote Target |
| **Audit** | `610849077178` | `adminakretrix+awsaudith@gmail.com` | Security Hub, GuardDuty, AWS Config Governance | Remote Target |
| **LogArchive** | `534283254869` | `adminakretrix+awslogarchive@gmail.com` | Centralized Immutable S3 Log Vault | Remote Target |
| **Backups** | `873310977008` | `adminakretrix+awsbackups@gmail.com` | Central AWS Backup Vault & Disaster Recovery | Remote Target |

- **Primary Region**: `us-east-1`

---

## Modular Two-Tier Architecture Layout

```text
akretrix-iac/
├── docs/                                # Documentation Hub
│   ├── INDEX.md                         # Documentation index
│   └── ORGANIZATION_ACCOUNTS.md        # Detailed breakdown of AWS accounts and functions
├── modules/                             # Tier 1: Granular Single-Service Building Block Modules
│   ├── s3-bucket/                       # Granular S3 bucket building block
│   ├── cloudfront-distribution/         # Granular CloudFront CDN building block
│   ├── api-gateway-http/                # Granular HTTP API Gateway building block
│   ├── lambda-function/                 # Granular Lambda function building block
│   ├── cloudwatch-log-group/            # Granular CloudWatch log group building block
│   ├── iam-role/                        # Granular IAM role building block
│   └── iam-oidc-provider/               # Granular IAM OIDC provider building block
├── root-modules/                        # Tier 2: Composite Solution Modules (invokes modules/*)
│   ├── github-oidc/                     # Composes iam-oidc-provider + iam-role
│   ├── static-site-s3-cloudfront/       # Composes s3-bucket + cloudfront-distribution (Reusable Static Web App Frontend)
│   ├── landing-page-s3-cloudfront/     # Composes s3-bucket + cloudfront-distribution
│   ├── free-tools-api/                  # Composes s3-bucket (artifacts)
│   ├── api-gateway/                     # Composes api-gateway-http + cloudwatch-log-group
│   └── lambda-function/                 # Composes lambda-function + iam-role + cloudwatch-log-group
└── aws/                                 # Terragrunt Live Environment definitions (invokes root-modules/*)
    ├── root.hcl                          # Root Terragrunt configuration (S3 state & AWS provider)
    ├── _env-common/                      # DRY Shared locals (common.hcl with all account IDs)
    ├── dev/                              # Dev Environment (us-east-1, Account: 568529364684)
    └── prod/                             # Production Environment (us-east-1, Account: 126517272255)
```

---

## Usage Instructions

### Prerequisites
- [Terraform](https://www.terraform.io/downloads) `>= 1.5.0` or OpenTofu
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/quick-start/) `>= 0.50.0`
- AWS CLI configured with credentials for the AkreTrix AWS accounts.

### Deployment Workflow

1. Navigate to the desired component in the `aws/` live directory:
   ```bash
   # Production Frontend
   cd aws/prod/us-east-1/landing-page/frontend

   # Dev Frontend
   cd aws/dev/us-east-1/landing-page/frontend
   ```

2. Run Terragrunt commands:
   ```bash
   # Plan changes
   terragrunt plan

   # Apply changes
   terragrunt apply
   ```

3. To plan/apply all components across an environment:
   ```bash
   cd aws/prod/us-east-1
   terragrunt run-all plan
   ```
