output "id" {
  value = "${aws_security_group.security_group.id}"
}

output "name" {
  value = "${aws_security_group.security_group.name}"
}

output "vpc_id" {
  value = "${aws_security_group.security_group.vpc_id}"
}
