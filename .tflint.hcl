plugin "aws" {
    enabled = true
    version = "0.28.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

config {
    module = true
    force = false
}

# Ignore Terragrunt cache and other non-module directories
ignore_directories = [
    ".terragrunt-cache",
    ".git",
    "aws",
    "docs"
]
