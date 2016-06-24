provider "aws" {
  region = "us-west-1"
}

variable "s3_suffix" {} # .bash_profileに環境変数定義 : TF_VAR_s3_suffix


variable "region" {
  default = "us-west-1"
}

variable "identifier" {
  default = "deployment"
}

variable "log_identifier" {
  default = "s3-log"
}

module "s3_log" {
  source = "../../../terraform/module/s3/internal"

  identifier = "${var.identifier}-${var.region}"
  suffix = "${var.s3_suffix}"
  log_identifier = "${var.log_identifier}-${var.region}"

  policy = "${file("../policy.json")}"
}
