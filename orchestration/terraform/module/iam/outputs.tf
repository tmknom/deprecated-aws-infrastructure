output "policy_arn" {
  value = "${aws_iam_policy.user_policy.arn}"
}

output "policy_name" {
  value = "${aws_iam_policy.user_policy.name}"
}
