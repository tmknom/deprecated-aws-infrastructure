# テスト環境にのみ開発用のセキュリティグループを定義する

# BaseAMI作成時に使用
module "initialize" {
  source = "../../terraform/module/security_group/cidr_blocks"

  name = "Initialize"
  description = "allow initialize base ami"
  environment = "${var.environment}"

  port = "22"
  cidr_block = "${var.administrator_ip_address}"
  vpc_id = "${var.vpc_id}"
}
