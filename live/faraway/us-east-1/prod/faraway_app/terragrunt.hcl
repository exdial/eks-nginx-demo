locals {
  default_tags = {
    Terraform = "true"
  }
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "fallback.hcl"))
  aws_profile = local.account_vars.locals.aws_profile
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/faraway-app"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  tags = local.default_tags

  aws_profile = local.aws_profile

  cluster_name = "faraway"
  cluster_version = "1.30"

  registry_username = ""
  registry_password = ""
}
