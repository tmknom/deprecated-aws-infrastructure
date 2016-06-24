provider "aws" {
  region = "us-west-1"
}

# 実行時に動的に環境変数定義 : TF_VAR_code_deploy_role_arn
variable "code_deploy_role_arn" {
}

module "wonderful_world" {
  source = "../../terraform/module/code_deploy"

  application_name = "wonderful-world"
  role_arn = "${var.code_deploy_role_arn}"
}
