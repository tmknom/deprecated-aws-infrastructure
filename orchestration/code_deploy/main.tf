variable "application_name" {}   # .bash_profileに環境変数定義 : TF_VAR_application_name

module "iam_role" {
  source = "../terraform/module/iam_role"

  role_name = "CodeDeploy"
  path = "/internal/"

  policy = "${file("policy.json")}"
}

module "code_deploy" {
  source = "../terraform/module/code_deploy"

  application_name = "${var.application_name}"
  deployment_group_name = "WebApplicationDeploymentGroup"
  role_arn = "${module.iam_role.role_arn}"
}
