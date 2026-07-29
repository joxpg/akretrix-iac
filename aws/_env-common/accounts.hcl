locals {
  # Central AWS Account Matrix
  accounts = {
    management     = "128117030885"
    deployment     = "830122794572"
    production     = "126517272255"

    nonproduction  = "568529364684"
    audit          = "610849077178"
    logarchive     = "534283254869"
    log-archive    = "534283254869"
    backups        = "873310977008"
  }
}
