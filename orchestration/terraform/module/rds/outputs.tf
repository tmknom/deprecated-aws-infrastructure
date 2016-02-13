output "id" {
  value = "${aws_db_instance.db_instance.id}"
}

output "arn" {
  value = "${aws_db_instance.db_instance.arn}"
}

output "endpoint" {
  value = "${aws_db_instance.db_instance.endpoint}"
}

output "db_name" {
  value = "${aws_db_instance.db_instance.name}"
}

output "master_user_name" {
  value = "${aws_db_instance.db_instance.username}"
}
