resource "aws_db_instance" "db_instance" {
  identifier = "${lower(var.environment)}-${lower(var.rds_name)}"
  port = "${var.db_port}"

  name = "${var.db_name}"
  username = "${var.master_user_name}"
  password = "${var.master_user_password}"

  availability_zone = "${var.availability_zone}"
  db_subnet_group_name = "${aws_db_subnet_group.db_subnet_group.name}"
  vpc_security_group_ids = ["${var.security_group_id}"]

  parameter_group_name = "${aws_db_parameter_group.db_parameter_group.name}"

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
    Name = "${var.environment}-${var.rds_name}-DbInstance"
    Environment = "${var.environment}"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${lower(var.environment)}-${lower(var.rds_name)}-db-subnet-group"
  description = "Db subnet group for ${var.environment} ${var.rds_name}"
  subnet_ids = ["${split(",", var.subnet_ids)}"]
  tags {
    Name = "${var.environment}-${var.rds_name}-DbSubnetGroup"
    Environment = "${var.environment}"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name = "${lower(var.environment)}-${lower(var.rds_name)}-${var.engine}"
  family = "${var.db_parameter_group_family}"
  description = "${var.environment} ${var.rds_name} parameter group"

  tags {
    Name = "${var.environment}-${var.rds_name}-DbParameterGroup"
    Environment = "${var.environment}"
  }


  parameter {
    name = "character_set_client"
    value = "${var.db_character_set}"
  }

  parameter {
    name = "character_set_connection"
    value = "${var.db_character_set}"
  }

  parameter {
    name = "character_set_database"
    value = "${var.db_character_set}"
  }

  parameter {
    name = "character_set_results"
    value = "${var.db_character_set}"
  }

  parameter {
    name = "character_set_server"
    value = "${var.db_character_set}"
  }


  parameter {
    name = "collation_connection"
    value = "${var.db_collation}"
  }

  parameter {
    name = "collation_server"
    value = "${var.db_collation}"
  }


  parameter {
    name = "skip-character-set-client-handshake"
    value = "1"
    apply_method = "${var.apply_pending_reboot}"
  }

  parameter {
    name = "tx_isolation"
    value = "READ-COMMITTED"
  }


  # http://bekkou68.hatenablog.com/entry/2014/09/16/200122
  parameter {
    name = "slow_query_log"
    value = "1"
  }

  parameter {
    name = "long_query_time"
    value = "0.5"
  }


  parameter {
    name = "max_heap_table_size"
    value = "${32 * 1024 * 1024}"
  }

  parameter {
    name = "tmp_table_size"
    value = "${32 * 1024 * 1024}"
  }


  parameter {
    name = "innodb_buffer_pool_dump_at_shutdown"
    value = 1
  }

  parameter {
    name = "innodb_buffer_pool_load_at_startup"
    value = 1
    apply_method = "${var.apply_pending_reboot}"
  }
}
