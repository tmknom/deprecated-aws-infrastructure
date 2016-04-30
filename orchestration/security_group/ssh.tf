module "ssh" {
  source = "../terraform/module/security_group/cidr_blocks"

  role = "SSH"
  description = "allow ssh only administrator"
  environment = "${var.production}"

  port = "${var.ssh_port}"
  cidr_block = "${var.localhost_cidr_block}"
  vpc_id = "${var.production_vpc_id}"
}

module "administration_ssh" {
  source = "../terraform/module/security_group/cidr_blocks"

  role = "SSH"
  description = "allow ssh only administrator"
  environment = "${var.administration}"

  port = "${var.ssh_port}"
  cidr_block = "${var.localhost_cidr_block}"
  vpc_id = "${var.administration_vpc_id}"
}
