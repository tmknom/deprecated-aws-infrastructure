module "instance_profile" {
  source = "../../terraform/module/instance_profile"

  role_name = "Rails"
  path = "/internal/ec2/"

  policy = "${file("policy.json")}"
}
