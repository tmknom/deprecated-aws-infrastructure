module "tech_news" {
  source = "../terraform/module/code_deploy"

  application_name = "tech-news"
  role_arn = "${module.iam_role.role_arn}"
}
