# AkreTrix IaC Documentation Index

This directory serves as the documentation hub for `akretrix-iac`.

## 📚 Core Documents

| Document | Description | Target Audience |
|----------|-------------|-----------------|
| **[`AGENTS.md`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/AGENTS.md)** | Instructions & rules for AI coding agents | AI Agents & Assistants |
| **[`ORGANIZATION_ACCOUNTS.md`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/docs/ORGANIZATION_ACCOUNTS.md)** | Breakdown of all 7 AWS Organization Accounts, IDs, Emails, and IaC functions | DevOps & Developers |
| **[`README.md`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/README.md)** | Repository usage, directory layout, and deployment instructions | All Engineers |

---

## 🧩 Root Module Reference Manual

- **[`root-modules/github-oidc`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/root-modules/github-oidc)**: IAM OpenID Connect provider and execution role creation for GitHub Actions.
- **[`root-modules/landing-page-s3-cloudfront`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/root-modules/landing-page-s3-cloudfront)**: S3 static bucket, CloudFront OAC, and CDN distribution.
- **[`root-modules/free-tools-api`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/root-modules/free-tools-api)**: Lambda packaging S3 bucket for SAM/CloudFormation tools API.
- **[`root-modules/api-gateway`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/root-modules/api-gateway)**: HTTP API Gateway module with CORS and CloudWatch logs.
- **[`root-modules/lambda-function`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/root-modules/lambda-function)**: Generic Lambda function module with API Gateway integration.

---

## 🌍 Live Terragrunt Environment Index

- **Production (`prod`)**: [`aws/prod/us-east-1/`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/aws/prod/us-east-1)
- **Development (`dev`)**: [`aws/dev/us-east-1/`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/aws/dev/us-east-1)
