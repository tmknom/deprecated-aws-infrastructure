resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"
  tags {
    Name = "${var.environment}-${var.region_name}-VPC"
    Environment = "${var.environment}"
    Region = "${var.region_name}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}-${var.region_name}-InternetGateway"
    Environment = "${var.environment}"
    Region = "${var.region_name}"
  }
}

resource "aws_route" "public_internet_gateway_route" {
  route_table_id = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "${var.default_route}"
  gateway_id = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}-${var.region_name}-${var.public_network}-RouteTable"
    Environment = "${var.environment}"
    Region = "${var.region_name}"
    Network = "${var.public_network}"
  }
}

resource "aws_route_table" "protected_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}-${var.region_name}-${var.protected_network}-RouteTable"
    Environment = "${var.environment}"
    Region = "${var.region_name}"
    Network = "${var.protected_network}"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.environment}-${var.region_name}-${var.private_network}-RouteTable"
    Environment = "${var.environment}"
    Region = "${var.region_name}"
    Network = "${var.private_network}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  count = "${length(compact(split(",", var.public_subnets)))}"
  cidr_block = "${element(split(",", var.public_subnets), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index % length(split(",", var.availability_zones)))}"
  tags {
    Name = "${var.environment}-${var.region_name}-${var.public_network}-Subnet-${count.index}"
    Environment = "${var.environment}"
    Region = "${var.region_name}"
    Network = "${var.public_network}"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "protected_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  count = "${length(compact(split(",", var.protected_subnets)))}"
  cidr_block = "${element(split(",", var.protected_subnets), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index % length(split(",", var.availability_zones)))}"
  tags {
    Name = "${var.environment}-${var.region_name}-${var.protected_network}-Subnet-${count.index}"
    Environment = "${var.environment}"
    Region = "${var.region_name}"
    Network = "${var.protected_network}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  count = "${length(compact(split(",", var.private_subnets)))}"
  cidr_block = "${element(split(",", var.private_subnets), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index % length(split(",", var.availability_zones)))}"
  tags {
    Name = "${var.environment}-${var.region_name}-${var.private_network}-Subnet-${count.index}"
    Environment = "${var.environment}"
    Region = "${var.region_name}"
    Network = "${var.private_network}"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count = "${length(compact(split(",", var.public_subnets)))}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "protected_route_table_association" {
  count = "${length(compact(split(",", var.protected_subnets)))}"
  subnet_id = "${element(aws_subnet.protected_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.protected_route_table.id}"
}

resource "aws_route_table_association" "private_route_table_association" {
  count = "${length(compact(split(",", var.private_subnets)))}"
  subnet_id = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}
