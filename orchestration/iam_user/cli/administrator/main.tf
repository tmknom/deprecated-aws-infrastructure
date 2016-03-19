variable "aws_cli_user" {} # .bash_profileに環境変数定義 : TF_VAR_aws_cli_user

module "iam_user" {
  source = "../../../terraform/module/iam_user"

  user_name = "${var.aws_cli_user}"
  role = "CliAdministrator"
  path = "/cli/administrator/"

  policy = "${file("policy.json")}"
}
