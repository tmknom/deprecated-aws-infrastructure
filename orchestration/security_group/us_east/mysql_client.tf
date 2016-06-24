module "production_mysql_client" {
  source = "../../terraform/module/security_group/cidr_blocks"

  role = "MySQLClient"
  description = "dummy security group for mysql client"
  environment = "${var.production}"

  port = "80"
  cidr_block = "${var.localhost_cidr_block}"
  vpc_id = "${var.production_vpc_id}"
}
