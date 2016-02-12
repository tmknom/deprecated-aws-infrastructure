module "iam_role" {
  source = "../terraform/module/iam_role"

  role_name = "code_deploy"
  path = "/internal/"
  assume_role_policy_json = "assume_role_policy.json"
  policy_json = "policy.json"
}

module "code_deploy" {
  source = "../terraform/module/code_deploy"

  application_name = "WebApplication"
  deployment_group_name = "WebApplicationDeploymentGroup"
  role_arn = "${module.iam_role.role_arn}"
}
