provider "aws" {
  region = "us-west-1"
}

variable "environment" {
  default = "Production"
}
variable "application" {
  default = "wonderful-world"
}

variable "public_subnet_ids" {}   # 実行時に動的に環境変数定義 : TF_VAR_subnet_id
variable "elb_security_groups" {} # 実行時に動的に環境変数定義 : TF_VAR_security_group_id

//module "production_tech_news" {
//  source = "../../terraform/module/elb"
//
//  subnets = "${var.public_subnet_ids}"
//  security_groups = "${var.elb_security_groups}"
//
//  environment = "${var.environment}"
//  application = "${var.application}"
//}
