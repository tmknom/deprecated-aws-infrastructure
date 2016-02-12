module "iam" {
  source = "../../terraform/module/instance_profile"

  role_name = "rails"
  path = "/instance_profile/"
  assume_role_policy_json = "assume_role_policy.json"
  policy_json = "policy.json"
}
