# BaseAMI作成時に使用
module "initialize" {
  source = "../terraform/module/security_group/cidr_blocks"

  role = "Initialize"
  description = "allow initialize base ami"
  environment = "${var.environment}"

  port = "22"
  cidr_block = "${var.administrator_ip_address}/32"
  vpc_id = "${var.vpc_id}"
}
