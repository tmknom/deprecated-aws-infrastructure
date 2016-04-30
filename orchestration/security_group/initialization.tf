module "initialization" {
  source = "../terraform/module/security_group/cidr_blocks"

  role = "Initialization"
  description = "allow initialize base ami"
  environment = "${var.administration}"

  port = "22"
  cidr_block = "${var.localhost_cidr_block}"
  vpc_id = "${var.administration_vpc_id}"
}
