variable "s3_suffix" {} # .bash_profileに環境変数定義 : TF_VAR_s3_suffix

variable "bucket_identifier" {
  default = "cloud-trail"
}

variable "name" {
  default = "DefaultTrail"
}

module "cloud_trail" {
  source = "../terraform/module/cloud_trail"

  name = "${var.name}"
  bucket_name = "${var.bucket_identifier}-${var.s3_suffix}"
}
