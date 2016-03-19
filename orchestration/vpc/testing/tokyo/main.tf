module "vpc" {
  source = "../../../terraform/module/vpc"

  environment = "Testing"
  region_name = "Tokyo"
  availability_zones = "ap-northeast-1a,ap-northeast-1c"

  vpc_cidr = "10.11.0.0/16"

  public_subnets = "10.11.0.0/24,10.11.1.0/24"
  protected_subnets = "10.11.64.0/24,10.11.65.0/24"
  private_subnets = "10.11.128.0/24,10.11.129.0/24"
}
