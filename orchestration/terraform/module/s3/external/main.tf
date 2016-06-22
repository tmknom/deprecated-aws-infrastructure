resource "aws_s3_bucket" "bucket" {
  bucket = "${var.identifier}-${var.suffix}"
  acl = "${var.acl}"
  policy = "${var.policy}"

  website {
    index_document = "index.html"
  }

  tags {
    Identifier = "${var.identifier}"
    Group = "${var.group}"
    Environment = "${var.environment}"
  }
}
