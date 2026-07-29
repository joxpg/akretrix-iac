# AGENTS GUIDE — AKRETRIX IAC REPOSITORY

This repository contains all Infrastructure as Code (IaC) for the **AkreTrix** organization.

## 📖 Mandatory Reading Order for AI Agents

When assisting with infrastructure, terraform modules, terragrunt live configs, or AWS resources, read these files in order:

1. **[`docs/ORGANIZATION_ACCOUNTS.md`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/docs/ORGANIZATION_ACCOUNTS.md)**: Details the 7 AWS account IDs, emails, roles, and functions.
2. **[`README.md`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/README.md)**: Main architecture overview, two-tier module layout, and execution steps.
3. **[`docs/INDEX.md`](file:///Users/johann.trigos/Documents/Github/organization-akretrix/akretrix-iac/docs/INDEX.md)**: Index of all module documentation and live environment configurations.

---

## 🏗️ Repository Architecture Rules

- **Granular Modules Directory (`modules/`)**: Granular, single-purpose building block modules for AWS services (`modules/s3-bucket`, `modules/cloudfront-distribution`). Write pure Terraform without provider locks or state backends.
- **Root Modules Directory (`root-modules/`)**: Composite solution modules (`root-modules/landing-page-s3-cloudfront`, `root-modules/free-tools-api`) that invoke and compose granular modules from `modules/`.
- **Terragrunt Live Directory (`aws/`)**:
  - `aws/root.hcl`: Configures global remote state in Deployment Account `830122794572` and generates the AWS provider for `us-east-1`.
  - `aws/_env-common/common.hcl`: Holds global account maps and state bucket names.
  - `aws/prod/us-east-1/`: Production live environment definitions targeting Production Account `126517272255`.
  - `aws/dev/us-east-1/`: Development live environment definitions targeting nonproduction Account `568529364684`.

## 📁 Module Organization Standard

To prevent the `modules/` and `root-modules/` directories from becoming cluttered as the infrastructure grows, all modules **MUST** be logically grouped into category subdirectories (namespaces). 
- **Correct**: `modules/iam/role`, `modules/storage/s3-bucket`, `modules/network/cloudfront`
- **Incorrect**: `modules/iam-role`, `modules/s3-bucket`
