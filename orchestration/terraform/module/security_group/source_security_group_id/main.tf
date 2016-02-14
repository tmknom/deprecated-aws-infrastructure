module "security_group" {
  source = "../common"

  name = "${var.name}"
  vpc_id = "${var.vpc_id}"
  description = "${var.description}"
}

resource "aws_security_group_rule" "ingress" {
  type = "ingress"

  from_port = "${var.port}"
  to_port = "${var.port}"
  protocol = "${var.protocol}"
  source_security_group_id = "${var.source_security_group_id}"

  security_group_id = "${module.security_group.id}"
}
