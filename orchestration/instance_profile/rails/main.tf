variable "s3_suffix" {}          # .bash_profileに環境変数定義 : TF_VAR_s3_suffix

variable "bucket_identifier" {
  default = "deployment"
}

module "instance_profile" {
  source = "../../terraform/module/instance_profile"

  role_name = "Rails"
  path = "/internal/ec2/"

  policy = "${template_file.policy_json.rendered}"
}

resource "template_file" "policy_json" {
  template = "${file("policy.json.tpl")}"
  vars {
    identifier = "${var.bucket_identifier}"
    suffix = "${var.s3_suffix}"
  }
}
