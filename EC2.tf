
### Set up Bastion host

resource "aws_instance" "bastion" {
  subnet_id     = "${aws_subnet.public_subnet.0.id}"
  ami           = "${var.bastion_ami}"
  instance_type = "${var.bastion_instance_type}"
  key_name      = "Mama's Bakery"

  tags {
    Name = "Bastion Host"
  }
}

### Create web servers



resource "aws_launch_template" "webserver_template" {
  name_prefix = "web"
  image_id = "${var.webserver_ami}"
  instance_type = "${var.webserver_instance_type}"
}

resource "aws_autoscaling_group" "webserver_asg" {
  availability_zones = "${var.availability_zone}"
  desired_capacity = "${length(var.availability_zone)}"
  max_size = "${length(var.availability_zone)}"
  min_size = "${length(var.availability_zone)}"
  launch_template = {
    id = "${aws_launch_template.webserver_template.id}"
    version = "$$Latest"
  }
  tags = [
    {
      key                 = "name"
      value               = "Web Server"
      propagate_at_launch = true
    } ]
}


### Create application servers

resource "aws_launch_template" "appserver_template" {
  name_prefix = "web"
  image_id = "${var.appserver_ami}"
  instance_type = "${var.appserver_instance_type}"
}

resource "aws_autoscaling_group" "appserver_asg" {
  availability_zones = "${var.availability_zone}"
  desired_capacity = "${length(var.availability_zone)}"
  max_size = "${length(var.availability_zone)}"
  min_size = "${length(var.availability_zone)}"
  launch_template = {
    id = "${aws_launch_template.appserver_template.id}"
    version = "$$Latest"
  }
  tags = [
    {
      key                 = "name"
      value               = "App Server"
      propagate_at_launch = true
    } ]
}

