module "rails" {
  source = "../terraform/module/security_group/cidr_blocks"

  role = "Rails"
  description = "allow http anywhere"
  environment = "${var.production}"

  port = "80"
  cidr_block = "0.0.0.0/0"
  vpc_id = "${var.production_vpc_id}"
}

module "testing_rails" {
  source = "../terraform/module/security_group/cidr_blocks"

  role = "Rails"
  description = "allow http only administrator"
  environment = "${var.testing}"

  port = "80"
  cidr_block = "${var.localhost_cidr_block}"
  vpc_id = "${var.production_vpc_id}"
}
