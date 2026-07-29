terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_ssm_parameter" "this" {
  name        = var.name
  type        = var.type
  value       = var.value
  description = var.description
  overwrite   = var.overwrite

  tags = merge(var.tags, {
    Name = var.name
  })
}
