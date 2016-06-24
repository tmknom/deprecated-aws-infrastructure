provider "aws" {
  region = "us-west-1"
}

variable "environment" {
  default = "Production"
}
variable "application" {
  default = "wonderful-world"
}

variable "ami_id" {}                # 実行時に動的に環境変数定義 : TF_VAR_ami_id
variable "subnet_id" {}             # 実行時に動的に環境変数定義 : TF_VAR_subnet_id
variable "security_group_id" {}     # 実行時に動的に環境変数定義 : TF_VAR_security_group_id
variable "rds_security_group_id" {} # 実行時に動的に環境変数定義 : TF_VAR_rds_security_group_id
variable "ssh_security_group_id" {} # 実行時に動的に環境変数定義 : TF_VAR_ssh_security_group_id
variable "created" {}               # 実行時に動的に環境変数定義 : TF_VAR_created

module "production_tech_news" {
  source = "../../../terraform/module/ec2/rails"

  instance_count = "1"

  ami_id = "${var.ami_id}"
  subnet_id = "${var.subnet_id}"

  instance_profile = "RailsInstanceProfile"
  instance_type = "t2.micro"
  volume_size = "8"

  security_group_id = "${var.security_group_id}"
  rds_security_group_id = "${var.rds_security_group_id}"
  ssh_security_group_id = "${var.ssh_security_group_id}"

  environment = "${var.environment}"
  application = "${var.application}"
  deployment_group = "${lower(var.environment)}-${var.application}"
  created = "${var.created}"
}
