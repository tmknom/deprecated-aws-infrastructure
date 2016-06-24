variable "production" {
  default = "Production"
}

variable "production_storage_size" {
  default = 15
}

module "security_group" {
  source = "../../terraform/module/security_group/source_security_group_id"

  role = "${var.engine}"
  description = "allow MySQL"
  environment = "${var.production}"

  port = "${var.db_port}"
  source_security_group_id = "${var.production_db_source_security_group_id}"
  vpc_id = "${var.production_vpc_id}"
}

module "rds" {
  source = "../../terraform/module/rds"

  engine = "${var.engine}"
  environment = "${var.production}"

  db_port = "${var.db_port}"
  master_user_name = "${var.db_master_user_name}"
  master_user_password = "${var.db_initial_password}"

  subnet_ids = "${var.production_db_subnet_ids}"
  security_group_id = "${module.security_group.id}"

  availability_zone = "${element(split(",", var.availability_zones), 1)}"
  storage_size = "${var.production_storage_size}"
  backup_retention_period = 5
  multi_az = false
}
