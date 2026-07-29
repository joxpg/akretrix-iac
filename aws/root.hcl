terragrunt_version_constraint = ">= 0.50.0"
terraform_version_constraint  = ">= 1.5.0"

locals {
  globals_vars  = read_terragrunt_config("${get_parent_terragrunt_dir()}/_env-common/globals.hcl")
  accounts_vars = read_terragrunt_config("${get_parent_terragrunt_dir()}/_env-common/accounts.hcl")
  roles_vars    = read_terragrunt_config("${get_parent_terragrunt_dir()}/_env-common/roles.hcl")

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  accountname      = local.environment_vars.locals.accountname

  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.region
  region_short = local.region_vars.locals.region_short

  organization      = local.globals_vars.locals.organization
  accounts          = local.accounts_vars.locals.accounts
  state_bucket_name = local.globals_vars.locals.state_bucket_name
  deployment_acc_id = local.accounts["deployment"]
  target_account_id = local.accounts[local.accountname]

  # Dynamic target deployment role lookup
  target_role_arn = lookup(
    local.roles_vars.locals.target_deployment_roles,
    local.accountname,
    "arn:aws:iam::${local.target_account_id}:role/${local.roles_vars.locals.deployment_role_name}"
  )
}

remote_state {
  backend = "s3"
  config = {
    encrypt      = true
    region       = local.region
    bucket       = local.state_bucket_name
    key          = "${path_relative_to_include()}/terraform.tfstate"
    use_lockfile = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"

%{ if local.target_account_id != local.deployment_acc_id ~}
  assume_role {
    role_arn     = "${local.target_role_arn}"
    session_name = "terragrunt-session-${local.env}"
  }
%{ endif ~}

  default_tags {
    tags = {
      Environment  = "${local.env}"
      ManagedBy    = "Terragrunt"
      Organization = "${local.organization}"
    }
  }
}
EOF
}
