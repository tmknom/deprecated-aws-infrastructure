module "wonderful_world" {
  source = "../terraform/module/code_deploy"

  application_name = "wonderful-world"
  role_arn = "${module.iam_role.role_arn}"
}
