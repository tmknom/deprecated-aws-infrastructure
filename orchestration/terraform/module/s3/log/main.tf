resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.identifier}-${var.suffix}"
  acl = "${var.acl}"
  policy = "${var.policy}"

  tags {
    Identifier = "${var.identifier}"
    Group = "${var.group}"
    Environment = "${var.environment}"
  }
}
