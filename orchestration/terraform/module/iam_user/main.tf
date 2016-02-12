provider "aws" {
  region = "${var.region}"
}

resource "aws_iam_group_membership" "group_user" {
  name = "${var.role_name}-membership"
  users = [
    "${aws_iam_user.user.name}",
  ]
  group = "${aws_iam_group.user_group.name}"
}

resource "aws_iam_user" "user" {
  name = "${var.user_name}"
  path = "${var.path}"
}

resource "aws_iam_policy_attachment" "user_attachment" {
  name = "${var.role_name}-attachment"
  policy_arn = "${aws_iam_policy.user_policy.arn}"
  groups = [
    "${aws_iam_group.user_group.name}"
  ]
}

resource "aws_iam_group" "user_group" {
  name = "${var.role_name}-group"
  path = "${var.path}"
}

resource "aws_iam_policy" "user_policy" {
  name = "${var.role_name}-policy"
  path = "${var.path}"
  policy = "${file("${var.policy_json}")}"
}
