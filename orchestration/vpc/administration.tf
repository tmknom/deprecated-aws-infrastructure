module "administration" {
  source = "../terraform/module/vpc"

  environment = "Administration"
  availability_zones = "ap-northeast-1a,ap-northeast-1c"

  vpc_cidr = "192.168.0.0/16"

  public_subnets = "192.168.0.0/24"
  protected_subnets = ""
  private_subnets = ""
}
