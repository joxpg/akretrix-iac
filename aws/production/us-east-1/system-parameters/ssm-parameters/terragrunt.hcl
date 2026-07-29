include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//root-modules/systems-manager/ssm-parameters"
}

inputs = {
  environment = "pdn"

  parameters = {
    wildcard_cert_arn = {
      name        = "/akretrix/acm/wildcard_certificate_arn"
      value       = "arn:aws:acm:us-east-1:126517272255:certificate/6a6f161a-d97b-4ffd-a7e4-a4da84510881"
      description = "ACM Certificate ARN for *.akretrix.com / api.akretrix.com"
    }
    destination_email = {
      name        = "/akretrix/landing-page/destination_email"
      value       = "contact@akretrix.com"
      description = "Destination email address for landing page contact form submissions"
    }
    source_email = {
      name        = "/akretrix/landing-page/source_email"
      value       = "noreply@akretrix.com"
      description = "Verified SES source email address for sending lead notifications"
    }
  }

  tags = {
    Environment = "pdn"
    Component   = "SystemParameters"
    Project     = "AkreTrix"
  }
}
