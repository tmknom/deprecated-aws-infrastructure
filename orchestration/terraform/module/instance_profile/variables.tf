variable "role_name" {
}

variable "path" {
}

variable "assume_role_policy_json" {
  default = "assume_role_policy.json"
}

variable "policy_json" {
  default = "policy.json"
}

variable "region" {
  default = "ap-northeast-1"
}
