output "role_arn" {
  value = "${aws_iam_role.role.arn}"
}

output "role_name" {
  value = "${aws_iam_role.role.name}"
}

output "policy_arn" {
  value = "${aws_iam_policy.policy.arn}"
}

output "policy_name" {
  value = "${aws_iam_policy.policy.name}"
}
