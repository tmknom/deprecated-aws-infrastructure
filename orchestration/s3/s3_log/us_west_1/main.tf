provider "aws" {
  region = "us-west-1"
}

variable "s3_suffix" {} # .bash_profileに環境変数定義 : TF_VAR_s3_suffix

variable "identifier" {
  default = "s3-log-us-west-1"
}

module "s3_log" {
  source = "../../../terraform/module/s3/s3_log"

  identifier = "${var.identifier}"
  suffix = "${var.s3_suffix}"

  policy = "${file("../policy.json")}"
}
