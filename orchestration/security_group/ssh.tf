variable "environment" {
  default = "Production"
}

module "ssh" {
  source = "../terraform/module/security_group/cidr_blocks"

  role = "SSH"
  description = "allow ssh only administrator"
  environment = "${var.environment}"

  port = "${var.ssh_port}"
  cidr_block = "${var.administrator_ip_address}/32"
  vpc_id = "${var.production_vpc_id}"
}
