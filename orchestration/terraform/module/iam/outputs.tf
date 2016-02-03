output "group_arn" {
  value = "${aws_iam_group.user_group.arn}"
}

output "group_name" {
  value = "${aws_iam_group.user_group.name}"
}

output "policy_arn" {
  value = "${aws_iam_policy.user_policy.arn}"
}

output "policy_name" {
  value = "${aws_iam_policy.user_policy.name}"
}
