module "instance_profile" {
  source = "../../terraform/module/instance_profile"

  role_name = "Initialization"
  path = "/internal/ec2/"

  policy = "${file("policy.json")}"
}
