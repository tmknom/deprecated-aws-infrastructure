module "iam_user" {
  source = "../../terraform/module/iam_user"

  user_name = "cli-admin"
  role_name = "cli-admin"
  path = "/cli/"
  policy_json = "cli_admin.json"
}
