module "iam_user" {
  source = "../../../terraform/module/iam_user"

  user_name = "cli-admin"
  role = "CliAdministrator"
  path = "/cli/administrator/"
}
