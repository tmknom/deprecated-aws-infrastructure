variable "environment" {
}

variable "vpc_cidr" {
}

variable "public_subnets" {
  default = ""
}

variable "private_subnets" {
  default = ""
}

variable "enable_dns_hostnames" {
  default = true
}

variable "enable_dns_support" {
  default = true
}

variable "default_route" {
  default = "0.0.0.0/0"
}

variable "availability_zones" {
  default = {
    "0" = "ap-northeast-1a"
    "1" = "ap-northeast-1c"
  }
}
