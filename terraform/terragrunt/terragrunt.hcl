locals {
  inputs        = read_terragrunt_config("inputs.hcl").inputs
  google_inputs = read_terragrunt_config("../google/inputs.hcl").inputs

  dir_parsed = regex(".*/terragrunt/(?P<env>.*?)/(?P<module>.*?)$", get_terragrunt_dir())
  env        = local.dir_parsed.env
  module     = local.dir_parsed.module

  keys_dir           = "${abspath(path_relative_from_include())}/../keys"
  google_credentials = "${local.keys_dir}/${local.google_inputs.CREDENTIALS_FILE}"
}

remote_state {
  backend = "gcs"

  config = {
    bucket      = local.google_inputs.STATE_BUCKET
    credentials = local.google_credentials
    prefix      = "terraform.tfstate"
    location    = local.google_inputs.REGION
    project     = local.google_inputs.PROJECT
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
  local.inputs,
  {
    KEYS_DIR = local.keys_dir
  }
)
