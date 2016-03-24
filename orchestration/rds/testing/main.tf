variable "environment" {
  default = "Testing"
}

# === ここから下は本番環境とテスト環境で同一内容 ===

variable "db_port" {}             # .bash_profileに環境変数定義 : TF_VAR_db_port
variable "db_master_user_name" {} # .bash_profileに環境変数定義 : TF_VAR_db_master_user_name
variable "db_initial_password" {} # .bash_profileに環境変数定義 : TF_VAR_db_initial_password

variable "vpc_id" {}                      # 実行時に動的に環境変数定義 : TF_VAR_vpc_id
variable "availability_zones" {}          # 実行時に動的に環境変数定義 : TF_VAR_availability_zones
variable "db_subnet_ids" {}               # 実行時に動的に環境変数定義 : TF_VAR_db_subnet_ids
variable "db_source_security_group_id" {} # 実行時に動的に環境変数定義 : TF_VAR_db_source_security_group_id

variable "engine" {
  default = "MySQL"
}

module "security_group" {
  source = "../../terraform/module/security_group/source_security_group_id"

  role = "${var.engine}"
  description = "allow MySQL"
  environment = "${var.environment}"

  port = "${var.db_port}"
  source_security_group_id = "${var.db_source_security_group_id}"
  vpc_id = "${var.vpc_id}"
}

module "rds" {
  source = "../../terraform/module/rds"

  engine = "${var.engine}"
  environment = "${var.environment}"

  db_port = "${var.db_port}"
  master_user_name = "${var.db_master_user_name}"
  master_user_password = "${var.db_initial_password}"

  subnet_ids = "${var.db_subnet_ids}"
  security_group_id = "${module.security_group.id}"

  availability_zone = "${element(split(",", var.availability_zones), 1)}"
  storage_size = 5
  backup_retention_period = 5
  multi_az = false
}
