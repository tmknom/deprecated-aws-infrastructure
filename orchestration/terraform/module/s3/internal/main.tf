resource "aws_s3_bucket" "bucket" {
  bucket = "${var.identifier}-${var.suffix}"
  acl = "${var.acl}"
  policy = "${var.policy}"

  logging {
    target_bucket = "${var.log_identifier}-${var.suffix}"
    target_prefix = "${var.identifier}/"
  }

  tags {
    Identifier = "${var.identifier}"
    Group = "${var.group}"
    Environment = "${var.environment}"
  }
}
