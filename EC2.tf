
data "aws_ami" "node_web_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["webserver*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "node_app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["appserver*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
### Set up Bastion host

resource "aws_instance" "bastion" {
  subnet_id                   = "${aws_subnet.public_subnet.0.id}"
  ami                         = "${var.bastion_ami}"
  instance_type               = "${var.bastion_instance_type}"
  key_name                    = "Mama's Bakery"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.bastion_security_group.id}"]

  tags {
    Name = "${var.deploy_type} - Bastion Host"
  }
}

### Create web servers



resource "aws_launch_template" "webserver_template" {
  lifecycle { create_before_destroy = true }
  
  image_id               = "${data.aws_ami.node_web_ami.id}"
  instance_type          = "${var.webserver_instance_type}"
  key_name               = "Mama's Bakery"
  vpc_security_group_ids = ["${aws_security_group.private_security_group.id}"]
}

resource "aws_autoscaling_group" "webserver_asg" {
  lifecycle { create_before_destroy = true }
  
  name                = "web-asg - ${aws_launch_template.webserver_template.name}"
  desired_capacity    = "${length(var.availability_zone)}"
  max_size            = "${length(var.availability_zone)}"
  min_size            = "${length(var.availability_zone)}"
  vpc_zone_identifier = ["${aws_subnet.private_subnet.*.id}"]
  launch_template     = {
    id      = "${aws_launch_template.webserver_template.id}"
    version = "$$Latest"
  }
  tags = [
    {
      key                 = "name"
      value               = "${var.deploy_type} - Web Server"
      propagate_at_launch = true
    } ]
}


### Create application servers

resource "aws_launch_template" "appserver_template" {
  lifecycle { create_before_destroy = true }
  
  image_id               = "${data.aws_ami.node_app_ami.id}"
  instance_type          = "${var.appserver_instance_type}"
  key_name               = "Mama's Bakery"
  vpc_security_group_ids = ["${aws_security_group.private_security_group.id}"]
  iam_instance_profile {
    name = "${var.deploy_type}_rds_profile"
    }
}

resource "aws_autoscaling_group" "appserver_asg" {
  lifecycle { create_before_destroy = true }
  
  name                = "app-asg - ${aws_launch_template.appserver_template.name}"
  desired_capacity    = "${length(var.availability_zone)}"
  max_size            = "${length(var.availability_zone)}"
  min_size            = "${length(var.availability_zone)}"
  vpc_zone_identifier = ["${aws_subnet.private_subnet.*.id}"]
  launch_template     = {
    id      = "${aws_launch_template.appserver_template.id}"
    version = "$$Latest"
  }
  tags = [
    {
      key                 = "name"
      value               = "${var.deploy_type} - App Server"
      propagate_at_launch = true
    } ]
}

