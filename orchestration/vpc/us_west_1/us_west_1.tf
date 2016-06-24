provider "aws" {
  region = "us-west-1"
}

module "us_west_1" {
  source = "../../terraform/module/vpc"

  environment = "Production"
  availability_zones = "us-west-1b,us-west-1c"

  vpc_cidr = "10.20.0.0/16"

  public_subnets = "10.20.0.0/24,10.20.1.0/24"
  protected_subnets = "10.20.64.0/24,10.20.65.0/24"
  private_subnets = "10.20.128.0/24,10.20.129.0/24"
}
