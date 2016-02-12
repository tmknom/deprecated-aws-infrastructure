module "iam" {
  source = "../../terraform/module/instance_profile"

  role_name = "rails"
  path = "/instance_profile/"
}
