provider "aws" {
  region = "us-east-1"
}

# 実行時に動的に環境変数定義 : TF_VAR_production_vpc_id
variable "production_vpc_id" {
}

# .bash_profileに環境変数定義 : TF_VAR_ssh_port
variable "ssh_port" {
}

variable "localhost_cidr_block" {
  default = "127.0.0.1/32"
}

variable "production" {
  default = "Production"
}

variable "testing" {
  default = "Testing"
}

variable "administration" {
  default = "Administration"
}
