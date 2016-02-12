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
  value = "${aws_internet_gateway.internet_gateway.id}"
}

output "internet_gateway_name" {
  value = "${aws_internet_gateway.internet_gateway.tags.Name}"
}

output "public_route_table_id" {
  value = "${aws_route_table.public_route_table.id}"
}

output "public_route_table_name" {
  value = "${aws_route_table.public_route_table.tags.Name}"
}

output "private_route_table_id" {
  value = "${aws_route_table.private_route_table.id}"
}

output "private_route_table_name" {
  value = "${aws_route_table.private_route_table.tags.Name}"
}

output "public_subnet_ids" {
  value = "${join(",", aws_subnet.public_subnet.*.id)}"
}

output "public_subnet_names" {
  value = "${join(",",aws_subnet.public_subnet.*.tags.Name)}"
}

output "private_subnet_ids" {
  value = "${join(",", aws_subnet.private_subnet.*.id)}"
}

output "private_subnet_names" {
  value = "${join(",",aws_subnet.private_subnet.*.tags.Name)}"
}
