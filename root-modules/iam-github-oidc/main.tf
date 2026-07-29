terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# -----------------------------------------------------------------------------
# OIDC Provider
# -----------------------------------------------------------------------------
module "oidc_provider" {
  source               = "../../modules/iam/oidc-provider"
  count                = var.create_oidc_provider ? 1 : 0
  create_oidc_provider = true

  tags = merge(var.tags, {
    Name = "GitHubActionsOIDCProvider"
  })
}

locals {
  # If we created the provider, use its ARN. Otherwise, use the existing one passed in.
  oidc_provider_arn = var.create_oidc_provider ? module.oidc_provider[0].arn : var.existing_oidc_provider_arn
}

# -----------------------------------------------------------------------------
# GitHub Actions Roles
# -----------------------------------------------------------------------------
module "github_actions_role" {
  source   = "../../modules/iam/role"
  for_each = var.roles
  
  name        = each.key
  description = "IAM Role assumed by GitHub Actions for repository: ${each.value.github_repository}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = local.oidc_provider_arn
        }
        Action = ["sts:AssumeRoleWithWebIdentity", "sts:TagSession"]
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              for branch in each.value.github_branches : (
                branch == "*" ? "repo:${each.value.github_org}*/${each.value.github_repository}*:*" : "repo:${each.value.github_org}*/${each.value.github_repository}*:ref:refs/heads/${branch}"
              )
            ]
          }
        }
      }
    ]
  })

  policy_statements   = each.value.policy_statements
  managed_policy_arns = each.value.managed_policy_arns

  tags = merge(var.tags, {
    Repository = each.value.github_repository
    ManagedBy  = "Terragrunt"
  })
}
