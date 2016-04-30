# 実行時に動的に環境変数定義 : TF_VAR_production_vpc_id
variable "production_vpc_id" {
}

# 実行時に動的に環境変数定義 : TF_VAR_administration_vpc_id
variable "administration_vpc_id" {
}

# .bash_profileに環境変数定義 : TF_VAR_administrator_ip_address
variable "administrator_ip_address" {
}

# .bash_profileに環境変数定義 : TF_VAR_ssh_port
variable "ssh_port" {
}

variable "production" {
  default = "Production"
}

variable "administration" {
  default = "Administration"
}
