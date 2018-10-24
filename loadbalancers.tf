resource "aws_lb" "application-lb" {
  name               = "${var.deploy_type}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.public_subnet.*.id}"]
  security_groups    = ["${aws_security_group.alb_security_group.id}"]

  enable_deletion_protection = false

}

resource "aws_lb" "network-lb" {
  name               = "${var.deploy_type}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.private_subnet.*.id}"]

  enable_deletion_protection = false

}

resource "aws_lb_target_group" "webtg" {
  name     = "${var.deploy_type}-webtg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.mainVPC.id}"
}
resource "aws_autoscaling_attachment" "asg_attachment_alb" {
  autoscaling_group_name = "${aws_autoscaling_group.webserver_asg.id}"
  alb_target_group_arn   = "${aws_alb_target_group.webtg.arn}"
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.application-lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.webtg.arn}"
  }
}