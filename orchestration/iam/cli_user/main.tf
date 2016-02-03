module "iam" {
  source = "../../terraform/module/iam"

  user_name = "cli-admin"
  role_name = "cli-admin"
  policy_json = "cli_admin.json"
}
