include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//root-modules/iam-github-oidc"
}

inputs = {
  create_oidc_provider = true
  
  roles = {
    "GitHubActionsRoleDeploy" = {
      github_org          = "joxpg"
      github_repositories = ["akretrix-landing-page", "akretrix-elearning"]
      github_branches     = ["main", "release/qa"]
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
            "arn:aws:s3:::pdn-akretrix-landing-page-static/*",
            "arn:aws:s3:::pdn-akretrix-elearning-static",
            "arn:aws:s3:::pdn-akretrix-elearning-static/*"
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
        },
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
            "arn:aws:s3:::akretrix-landing-page-backend-pdn",
            "arn:aws:s3:::akretrix-landing-page-backend-pdn/*",
            "arn:aws:s3:::akretrix-landing-page-backend-qa",
            "arn:aws:s3:::akretrix-landing-page-backend-qa/*"
          ]
        },
        {
          Effect = "Allow"
          Action = [
            "cloudformation:CreateStack",
            "cloudformation:UpdateStack",
            "cloudformation:DeleteStack",
            "cloudformation:DescribeStacks",
            "cloudformation:DescribeStackEvents",
            "cloudformation:GetTemplateSummary",
            "cloudformation:CreateChangeSet",
            "cloudformation:ExecuteChangeSet",
            "cloudformation:DescribeChangeSet",
            "cloudformation:DeleteChangeSet"
          ]
          Resource = [
            "arn:aws:cloudformation:us-east-1:126517272255:stack/akretrix-landing-page-*",
            "arn:aws:cloudformation:us-east-1:568529364684:stack/akretrix-landing-page-*"
          ]
        },
        {
          Effect = "Allow"
          Action = ["iam:PassRole"]
          Resource = [
            "arn:aws:iam::126517272255:role/akretrix-landing-page-backend-pdn-cfn-deploy-role",
            "arn:aws:iam::568529364684:role/akretrix-landing-page-backend-qa-cfn-deploy-role"
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
