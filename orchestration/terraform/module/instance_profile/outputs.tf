output "instance_profile_arn" {
  value = "${aws_iam_instance_profile.instance_profile.arn}"
}

output "instance_profile_name" {
  value = "${aws_iam_instance_profile.instance_profile.name}"
}

output "role_arn" {
  value = "${module.iam_role.role_arn}"
}

output "role_name" {
  value = "${module.iam_role.role_name}"
}

output "policy_arn" {
  value = "${module.iam_role.policy_arn}"
}

output "policy_name" {
  value = "${module.iam_role.policy_name}"
}
