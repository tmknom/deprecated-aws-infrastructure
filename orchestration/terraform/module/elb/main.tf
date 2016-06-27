resource "aws_elb" "elb" {
  name = "${var.environment}-Elb-${var.application}"

  subnets = [
    "${split(",", var.subnets)}"
  ]

  security_groups = [
    "${split(",", var.security_groups)}"
  ]

  listener {
    instance_port = "${var.instance_port}"
    instance_protocol = "${var.instance_protocol}"
    lb_port = "${var.lb_port}"
    lb_protocol = "${var.lb_protocol}"
  }

  health_check {
    unhealthy_threshold = "${var.unhealthy_threshold}"
    healthy_threshold = "${var.healthy_threshold}"
    timeout = "${var.health_check_timeout}"
    target = "${var.health_check_target}"
    interval = "${var.health_check_interval}"
  }

  cross_zone_load_balancing = "${var.cross_zone_load_balancing}"
  connection_draining = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"
  idle_timeout = "${var.idle_timeout}"

  //  access_logs {
  //    bucket = "foo"
  //    bucket_prefix = "bar"
  //    interval = 60
  //  }

  tags {
    Name = "${var.environment}-Elb-${var.application}"

    Environment = "${var.environment}"
    Application = "${var.application}"
  }
}
