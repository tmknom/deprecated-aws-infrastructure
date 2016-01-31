provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "mod" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"
  tags {
    Name = "${var.vpc_name}"
  }
}
