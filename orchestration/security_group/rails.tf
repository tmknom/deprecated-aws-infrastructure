module "rails" {
  source = "../terraform/module/security_group/cidr_blocks"

  role = "Rails"
  description = "allow http anywhere"
  environment = "${var.production}"

  port = "3000"
  cidr_block = "0.0.0.0/0"
  vpc_id = "${var.production_vpc_id}"
}
