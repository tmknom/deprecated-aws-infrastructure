variable "rds_name" {
}

variable "environment" {
}


variable "db_port" {
  default = "3306"
}


variable "db_name" {
}

variable "master_user_name" {
}

variable "master_user_password" {
}


variable "availability_zone" {
  default = "ap-northeast-1c"
}

variable "db_subnet_group_name" {
  default = "default"
}

variable "security_group_id" {
}


variable "parameter_group_name" {
  default = "sample-mysql-param"
}


variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "5.6.23"
}


variable "instance_type" {
  default = "db.t2.micro"
}

variable "storage_size" {
  default = 5
}

variable "storage_type" {
  default = "gp2"
}


variable "backup_retention_period" {
  default = 0
}

variable "backup_window" {
  default = "18:19-18:49"
}

variable "maintenance_window" {
  default = "fri:19:19-fri:19:49"
}


variable "multi_az" {
  default = false
}

variable "publicly_accessible" {
  default = false
}

variable "copy_tags_to_snapshot" {
  default = true
}

variable "auto_minor_version_upgrade" {
  default = true
}
