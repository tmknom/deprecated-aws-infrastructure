output "instance_id" {
  value = "${aws_instance.rails.id}"
}

output "instance_public_ip" {
  value = "${aws_instance.rails.public_ip}"
}

output "instance_private_ip" {
  value = "${aws_instance.rails.private_ip}"
}
