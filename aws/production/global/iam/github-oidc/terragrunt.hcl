include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//root-modules/iam-github-oidc"
}

inputs = {
  create_oidc_provider = true
  
  roles = {
    "GitHubActionsLandingPageDeploy" = {
      github_repository = "akretrix-landing-page"
      github_branches   = ["main", "release/qa"]
      policy_statements = [
        {
          Effect = "Allow"
          Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:DeleteObject",
            "s3:GetBucketLocation"
          ]
          Resource = [
            "arn:aws:s3:::pdn-akretrix-landing-page-static",
            "arn:aws:s3:::pdn-akretrix-landing-page-static/*"
          ]
        },
        {
          Effect = "Allow"
          Action = [
            "cloudfront:CreateInvalidation"
          ]
          Resource = [
            "arn:aws:cloudfront::126517272255:distribution/E2IOCDNBH2FVYW"
          ]
        }
      ]
    }
  }

  tags = {
    Environment = "pdn"
    Component   = "IAM-GitHub-OIDC"
    Project     = "AkreTrix"
  }
}
