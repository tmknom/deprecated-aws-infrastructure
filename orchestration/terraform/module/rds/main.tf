resource "aws_db_instance" "db_instance" {
  identifier = "${lower(var.rds_name)}-${lower(var.environment)}-db-instance"
  port = "${var.db_port}"

  name = "${var.db_name}"
  username = "${var.master_user_name}"
  password = "${var.master_user_password}"

  availability_zone = "${var.availability_zone}"
  db_subnet_group_name = "${var.db_subnet_group_name}"
  vpc_security_group_ids = ["${var.security_group_id}"]

  parameter_group_name = "${var.parameter_group_name}"

  engine = "${var.engine}"
  engine_version = "${var.engine_version}"

  instance_class = "${var.instance_type}"
  allocated_storage = "${var.storage_size}"
  storage_type = "${var.storage_type}"

  backup_retention_period = "${var.backup_retention_period}"
  backup_window = "${var.backup_window}"
  maintenance_window = "${var.maintenance_window}"

  multi_az = "${var.multi_az}"
  publicly_accessible = "${var.publicly_accessible}"
  copy_tags_to_snapshot = "${var.copy_tags_to_snapshot}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"

  tags {
    Name = "${var.rds_name}-${var.environment}-DbInstance"
    Environment = "${var.environment}"
  }
}
