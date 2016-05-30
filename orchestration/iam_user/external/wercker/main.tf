variable "aws_default_region" {} # .bash_profileに環境変数定義 : TF_VAR_aws_default_region
variable "aws_account_id" {}     # .bash_profileに環境変数定義 : TF_VAR_aws_account_id
variable "s3_suffix" {}          # .bash_profileに環境変数定義 : TF_VAR_s3_suffix

variable "bucket_identifier" {
  default = "deployment"
}

module "iam_user" {
  source = "../../../terraform/module/iam_user"

  user_name = "Wercker"
  role = "Wercker"
  path = "/external/"
  policy = "${template_file.policy_json.rendered}"
}

resource "template_file" "policy_json" {
  template = "${file("policy.json.tpl")}"
  vars {
    region = "${var.aws_default_region}"
    aws_account_id = "${var.aws_account_id}"
    identifier = "${var.bucket_identifier}"
    suffix = "${var.s3_suffix}"
  }
}
