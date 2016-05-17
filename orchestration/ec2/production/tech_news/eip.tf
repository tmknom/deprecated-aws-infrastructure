resource "aws_eip_association" "production_tech_news_eip_association" {
  instance_id = "${module.production_tech_news.instance_id}"
  allocation_id = "${aws_eip.production_tech_news_eip.id}"
}

resource "aws_eip" "production_tech_news_eip" {
  vpc = true
}
