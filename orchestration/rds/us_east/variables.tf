provider "aws" {
  region = "us-east-1"
}

variable "db_port" {}             # .bash_profileに環境変数定義 : TF_VAR_db_port
variable "db_master_user_name" {} # .bash_profileに環境変数定義 : TF_VAR_db_master_user_name
variable "db_initial_password" {} # .bash_profileに環境変数定義 : TF_VAR_db_initial_password

variable "availability_zones" {}  # 実行時に動的に環境変数定義 : TF_VAR_availability_zones

variable "production_vpc_id" {}                      # 実行時に動的に環境変数定義 : TF_VAR_production_vpc_id
variable "production_db_subnet_ids" {}               # 実行時に動的に環境変数定義 : TF_VAR_production_db_subnet_ids
variable "production_db_source_security_group_id" {} # 実行時に動的に環境変数定義 : TF_VAR_production_db_source_security_group_id

variable "administration_vpc_id" {}                      # 実行時に動的に環境変数定義 : TF_VAR_administration_vpc_id
variable "administration_db_subnet_ids" {}               # 実行時に動的に環境変数定義 : TF_VAR_administration_db_subnet_ids
variable "administration_db_source_security_group_id" {} # 実行時に動的に環境変数定義 : TF_VAR_administration_db_source_security_group_id

variable "engine" {
  default = "MySQL"
}
