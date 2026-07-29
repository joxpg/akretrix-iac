terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "ssm_parameter" {
  for_each    = var.parameters
  source      = "../../../modules/systems-manager/ssm-parameter"
  name        = each.value.name
  type        = lookup(each.value, "type", "String")
  value       = each.value.value
  description = lookup(each.value, "description", null)
  overwrite   = lookup(each.value, "overwrite", true)

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      ManagedBy   = "Terragrunt"
    }
  )
}
