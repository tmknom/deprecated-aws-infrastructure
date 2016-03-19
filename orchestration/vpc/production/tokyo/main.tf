module "vpc" {
  source = "../../../terraform/module/vpc"

  environment = "Production"
  region_name = "Tokyo"
  availability_zones = "ap-northeast-1a,ap-northeast-1c"

  vpc_cidr = "10.10.0.0/16"

  public_subnets = "10.10.0.0/24,10.10.1.0/24"
  protected_subnets = "10.10.64.0/24,10.10.65.0/24"
  private_subnets = "10.10.128.0/24,10.10.129.0/24"
}
