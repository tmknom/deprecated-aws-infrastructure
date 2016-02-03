provider "aws" {
  region = "${var.region}"
}

resource "aws_iam_group" "user_group" {
  name = "${var.role_name}-group"
  path = "/"
}

resource "aws_iam_policy" "user_policy" {
  name = "${var.role_name}-policy"
  path = "/"
  policy = "${file("${var.policy_json}")}"
}
