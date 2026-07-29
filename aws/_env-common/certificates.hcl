locals {
  acm_certificates = {
    # Example of a fully populated certificate definition
    # my_service_prod = {
    #   account = "126517272255"
    #   region  = "us-east-1"
    #   alias   = "akretrix.com"
    #   arn     = "arn:aws:acm:us-east-1:126517272255:certificate/..."
    # }

    # The certificate you provided earlier (Note: this is in the deployment account)
    production = {
      "us-east-1" = {
        aliases = ["akretrix.com", "www.akretrix.com", "api.akretrix.com", "*.akretrix.com"]
        arn   = "arn:aws:acm:us-east-1:126517272255:certificate/6a6f161a-d97b-4ffd-a7e4-a4da84510881"
      }
    }
  }
}
