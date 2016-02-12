resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"
  tags {
    Name = "${var.environment}VPC"
    Environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}InternetGateway"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}-PublicRouteTable"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "${var.default_route}"
  gateway_id = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}-PrivateRouteTable"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  count = "${length(compact(split(",", var.public_subnets)))}"
  cidr_block = "${element(split(",", var.public_subnets), count.index)}"
  availability_zone = "${lookup(var.availability_zones, count.index % 2)}"
  tags {
    Name = "${var.environment}-PublicSubnet-${count.index}"
    Environment = "${var.environment}"
  }
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public" {
  count = "${length(compact(split(",", var.public_subnets)))}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  count = "${length(compact(split(",", var.private_subnets)))}"
  cidr_block = "${element(split(",", var.private_subnets), count.index)}"
  availability_zone = "${lookup(var.availability_zones, count.index % 2)}"
  tags {
    Name = "${var.environment}-PrivateSubnet-${count.index}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(compact(split(",", var.private_subnets)))}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}
