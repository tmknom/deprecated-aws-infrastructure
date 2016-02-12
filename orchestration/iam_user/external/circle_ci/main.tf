module "iam_user" {
  source = "../../../terraform/module/iam_user"

  user_name = "CircleCI"
  role = "CircleCI"
  path = "/external/"
}
