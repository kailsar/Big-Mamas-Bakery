resource "aws_lb" "application-lb" {
  name               = "${var.deploy_type}-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.private_subnet.*.id}"]

  enable_deletion_protection = false

}


resource "aws_lb" "network-lb" {
  name               = "${var.deploy_type}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.private_subnet.*.id}"]

  enable_deletion_protection = false

}
