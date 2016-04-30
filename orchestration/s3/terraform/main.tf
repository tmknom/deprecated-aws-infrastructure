variable "s3_suffix" {} # .bash_profileに環境変数定義 : TF_VAR_s3_suffix

variable "identifier" {
  default = "terraform"
}

module "s3_administration" {
  source = "../../terraform/module/s3/internal"

  identifier = "${var.identifier}"
  suffix = "${var.s3_suffix}"

  policy = "${file("policy.json")}"
}
