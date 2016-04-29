variable "administrator_ip_address" {} # .bash_profileに環境変数定義 : TF_VAR_administrator_ip_address
variable "ssh_port" {}                 # .bash_profileに環境変数定義 : TF_VAR_ssh_port
variable "vpc_id" {}                   # 実行時に動的に環境変数定義 : TF_VAR_vpc_id
variable "environment" {
  default = "Production"
}

module "ssh" {
  source = "../terraform/module/security_group/cidr_blocks"

  role = "SSH"
  description = "allow ssh only administrator"
  environment = "${var.environment}"

  port = "${var.ssh_port}"
  cidr_block = "${var.administrator_ip_address}/32"
  vpc_id = "${var.vpc_id}"
}
