terraform {
  source = "../../../modules/google"
}

include {
  path = find_in_parent_folders()
}
