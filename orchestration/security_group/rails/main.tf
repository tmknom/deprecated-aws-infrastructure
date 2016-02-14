variable "vpc_id" {}        # .bash_profileに環境変数定義 : TF_VAR_vpc_id

module "security_group" {
  source = "../../terraform/module/security_group/cidr_blocks"

  name = "Rails"
  cidr_block = "0.0.0.0/0"
  vpc_id = "${var.vpc_id}"
  description = "allow http anywhere"

  port = "3000"
}
