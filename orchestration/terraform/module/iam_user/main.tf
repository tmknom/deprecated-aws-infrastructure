resource "aws_iam_group_membership" "membership" {
  name = "${var.role}Membership"
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
  name = "${var.role}Attachment"
  policy_arn = "${aws_iam_policy.policy.arn}"
  groups = [
    "${aws_iam_group.group.name}"
  ]
}

resource "aws_iam_group" "group" {
  name = "${var.role}Group"
  path = "${var.path}"
}

resource "aws_iam_policy" "policy" {
  name = "${var.role}Policy"
  path = "${var.path}"
  policy = "${var.policy}"
}
