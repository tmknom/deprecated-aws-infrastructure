module "iam_role" {
  source = "../terraform/module/iam_role"

  role_name = "CodeDeploy"
  path = "/internal/"

  policy = "${file("policy.json")}"
}
