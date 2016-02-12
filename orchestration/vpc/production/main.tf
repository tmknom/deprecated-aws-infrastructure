module "vpc" {
  source = "../../terraform/module/vpc"

  environment = "Production"
  vpc_cidr = "172.17.0.0/16"
  public_subnets = "172.17.10.0/24,172.17.11.0/24"
  private_subnets = "172.17.100.0/24,172.17.101.0/24"
}
