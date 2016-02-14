resource "aws_security_group" "security_group" {
  name = "${var.name}SecurityGroup"

  ingress {
    from_port = "${var.port}"
    to_port = "${var.port}"
    cidr_blocks = ["${var.cidr_block}"]
    protocol = "${var.protocol}"
  }

  egress {
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  }

  vpc_id = "${var.vpc_id}"
  description = "${var.description}"

  tags {
    Name = "${var.name}SecurityGroup"
  }
}
