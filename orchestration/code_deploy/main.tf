module "iam_role" {
  source = "../terraform/module/iam_role"

  role_name = "CodeDeploy"
  path = "/internal/"
}

module "code_deploy" {
  source = "../terraform/module/code_deploy"

  application_name = "WebApplication"
  deployment_group_name = "WebApplicationDeploymentGroup"
  role_arn = "${module.iam_role.role_arn}"
}
