# Root terragrunt.hcl configuration
#
locals {
  # auto load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "fallback.hcl"))
  aws_profile  = local.account_vars.locals.aws_profile == "" ? "default" : local.account_vars.locals.aws_profile

  # auto load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "fallback.hcl"))
  aws_region  = local.region_vars.locals.aws_region == "" ? "us-east-1" : local.region_vars.locals.aws_region
}

# These are automatically merged into the child `terragrunt.hcl` config
# via the include block.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals
)

generate "versions" {
  path      = "_versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      required_version = "~> 1.5.7"

      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 5.0"
        }
        kubernetes = {
          source = "hashicorp/kubernetes"
          version = "2.31.0"
        }
      }
    }
  EOF
}

generate "providers" {
  path      = "_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "aws" {
      region  = "${local.aws_region}"
      profile = "${local.aws_profile}"
      insecure = false
      default_tags {
        tags = {
          Terraform = true
        }
      }
    }
  EOF
}

terraform {
  # Execute "init" before "plan" every time
  before_hook "before_hook" {
    commands = ["plan"]
    execute  = ["terraform", "init"]
  }
}
