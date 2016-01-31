output "environment" {
  value = "${var.environment}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "vpc_name" {
  value = "${aws_vpc.vpc.tags.Name}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "internet_gateway_name" {
  value = "${aws_internet_gateway.igw.tags.Name}"
}

output "public_route_table_id" {
  value = "${aws_route_table.public.id}"
}

output "public_route_table_name" {
  value = "${aws_route_table.public.tags.Name}"
}
