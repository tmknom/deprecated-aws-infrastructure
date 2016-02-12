provider "aws" {
  region = "${var.region}"
}

module "iam_role" {
  source = "../iam_role"

  role_name = "${var.role_name}"
  assume_role_policy_json = "${var.assume_role_policy_json}"
  policy_json = "${var.policy_json}"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.role_name}InstanceProfile"
  roles = ["${module.iam_role.role_name}"]
}
