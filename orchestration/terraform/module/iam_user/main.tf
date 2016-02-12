provider "aws" {
  region = "${var.region}"
}

resource "aws_iam_group_membership" "membership" {
  name = "${var.role_name}Membership"
  users = [
    "${aws_iam_user.user.name}",
  ]
  group = "${aws_iam_group.group.name}"
}

resource "aws_iam_user" "user" {
  name = "${var.user_name}"
  path = "${var.path}"
}

resource "aws_iam_policy_attachment" "attachment" {
  name = "${var.role_name}Attachment"
  policy_arn = "${aws_iam_policy.policy.arn}"
  groups = [
    "${aws_iam_group.group.name}"
  ]
}

resource "aws_iam_group" "group" {
  name = "${var.role_name}Group"
  path = "${var.path}"
}

resource "aws_iam_policy" "policy" {
  name = "${var.role_name}Policy"
  path = "${var.path}"
  policy = "${file("${var.policy_json}")}"
}
