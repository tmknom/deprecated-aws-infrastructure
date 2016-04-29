variable "vpc_id" {} # 実行時に動的に環境変数定義 : TF_VAR_vpc_id
variable "environment" {
  default = "Production"
}

module "rails" {
  source = "../terraform/module/security_group/cidr_blocks"

  role = "Rails"
  description = "allow http anywhere"
  environment = "${var.environment}"

  port = "3000"
  cidr_block = "0.0.0.0/0"
  vpc_id = "${var.vpc_id}"
}
