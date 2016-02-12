output "user_arn" {
  value = "${aws_iam_user.user.arn}"
}

output "user_name" {
  value = "${aws_iam_user.user.name}"
}

output "group_arn" {
  value = "${aws_iam_group.group.arn}"
}

output "group_name" {
  value = "${aws_iam_group.group.name}"
}

output "policy_arn" {
  value = "${aws_iam_policy.policy.arn}"
}

output "policy_name" {
  value = "${aws_iam_policy.policy.name}"
}

output "path" {
  value = "${aws_iam_user.user.path}"
}
