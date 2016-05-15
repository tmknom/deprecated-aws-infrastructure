variable "administration" {
  default = "Administration"
}
variable "administration_storage_size" {
  default = 5
}

module "administration_security_group" {
  source = "../terraform/module/security_group/source_security_group_id"

  role = "${var.engine}"
  description = "allow MySQL"
  environment = "${var.administration}"

  port = "${var.db_port}"
  source_security_group_id = "${var.administration_db_source_security_group_id}"
  vpc_id = "${var.administration_vpc_id}"
}

module "administration_rds" {
  source = "../terraform/module/rds"

  engine = "${var.engine}"
  environment = "${var.administration}"

  db_port = "${var.db_port}"
  master_user_name = "${var.db_master_user_name}"
  master_user_password = "${var.db_initial_password}"

  subnet_ids = "${var.administration_db_subnet_ids}"
  security_group_id = "${module.administration_security_group.id}"

  availability_zone = "${element(split(",", var.availability_zones), 1)}"
  storage_size = "${var.administration_storage_size}"
  backup_retention_period = 1
  multi_az = false
}
