variable "my_ip_address" {} # .bash_profileに環境変数定義 : TF_VAR_my_ip_address
variable "vpc_id" {}        # .bash_profileに環境変数定義 : TF_VAR_vpc_id
variable "ssh_port" {}      # .bash_profileに環境変数定義 : TF_VAR_ssh_port

module "security_group" {
  source = "../../terraform/module/security_group"

  name = "SSH"
  cidr_block = "${var.my_ip_address}"
  vpc_id = "${var.vpc_id}"
  description = "allow ssh only administrator"

  port = "${var.ssh_port}"
}
