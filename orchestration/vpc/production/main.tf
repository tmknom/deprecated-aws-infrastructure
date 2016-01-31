module "production_vpc" {
  source = "../../terraform/module/network"

  vpc_name = "production"
  vpc_cidr = "172.17.0.0/16"
}
