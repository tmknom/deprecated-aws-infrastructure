module "security_group" {
  source = "../common"

  role = "${var.role}"
  vpc_id = "${var.vpc_id}"
  description = "${var.description}"
  environment = "${var.environment}"
}

resource "aws_security_group_rule" "ingress" {
  type = "ingress"

  from_port = "${var.port}"
  to_port = "${var.port}"
  protocol = "${var.protocol}"
  cidr_blocks = ["${var.cidr_block}"]

  security_group_id = "${module.security_group.id}"
}
