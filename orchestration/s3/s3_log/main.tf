variable "s3_suffix" {} # .bash_profileに環境変数定義 : TF_VAR_s3_suffix

variable "identifier" {
  default = "s3-log"
}

module "log_bucket" {
  source = "../../terraform/module/s3/log"

  identifier = "${var.identifier}"
  suffix = "${var.s3_suffix}"

  policy = "${file("policy.json")}"
}
