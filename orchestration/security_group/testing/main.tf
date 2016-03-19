variable "environment" {
  default = "Testing"
}

# === ここから下は本番環境とテスト環境で同一内容 ===


variable "administrator_ip_address" {} # .bash_profileに環境変数定義 : TF_VAR_administrator_ip_address
variable "ssh_port" {}                 # .bash_profileに環境変数定義 : TF_VAR_ssh_port

variable "vpc_id" {} # 実行時に動的に環境変数定義 : TF_VAR_vpc_id

module "ssh" {
  source = "../../terraform/module/security_group/cidr_blocks"

  name = "SSH"
  description = "allow ssh only administrator"
  environment = "${var.environment}"

  port = "${var.ssh_port}"
  cidr_block = "${var.administrator_ip_address}"
  vpc_id = "${var.vpc_id}"
}

module "rails" {
  source = "../../terraform/module/security_group/cidr_blocks"

  name = "Rails"
  description = "allow http anywhere"
  environment = "${var.environment}"

  port = "3000"
  cidr_block = "0.0.0.0/0"
  vpc_id = "${var.vpc_id}"
}
