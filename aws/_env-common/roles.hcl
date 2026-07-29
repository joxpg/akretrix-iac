locals {
  # Transversal IAM Deployment Role Configuration
  deployment_role_name = "AkretrixTerragruntDeploymentRole"

  target_deployment_roles = {
    production     = "arn:aws:iam::126517272255:role/AkretrixTerragruntDeploymentRole"
    prod           = "arn:aws:iam::126517272255:role/AkretrixTerragruntDeploymentRole"
    pdn            = "arn:aws:iam::126517272255:role/AkretrixTerragruntDeploymentRole"
    nonproduction  = "arn:aws:iam::568529364684:role/AkretrixTerragruntDeploymentRole"
    non-production = "arn:aws:iam::568529364684:role/AkretrixTerragruntDeploymentRole"
    dev            = "arn:aws:iam::568529364684:role/AkretrixTerragruntDeploymentRole"
    audit          = "arn:aws:iam::610849077178:role/AkretrixTerragruntDeploymentRole"
    logarchive     = "arn:aws:iam::534283254869:role/AkretrixTerragruntDeploymentRole"
    log-archive    = "arn:aws:iam::534283254869:role/AkretrixTerragruntDeploymentRole"
    backups        = "arn:aws:iam::873310977008:role/AkretrixTerragruntDeploymentRole"
    management     = "arn:aws:iam::128117030885:role/AkretrixTerragruntDeploymentRole"
  }
}
