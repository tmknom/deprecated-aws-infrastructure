module "initialize" {
  source = "../terraform/module/security_group/cidr_blocks"

  role = "Initialize"
  description = "allow initialize base ami"
  environment = "${var.administration}"

  port = "22"
  cidr_block = "${var.administrator_ip_address}/32"
  vpc_id = "${var.administration_vpc_id}"
}
