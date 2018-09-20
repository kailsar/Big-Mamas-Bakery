
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

resource "aws_instance" "web_server" {
  count         = "${length(var.availability_zone)}"
  subnet_id     = "${aws_subnet.private_subnet.*.id[count.index]}"
  ami           = "${var.webserver_ami}"
  instance_type = "${var.webserver_instance_type}"
  key_name      = "Mama's Bakery"

  tags {
    Name = "Web Server"
  }
}

### Create application servers

resource "aws_instance" "app_server" {
  count         = "${length(var.availability_zone)}"
  subnet_id     = "${aws_subnet.private_subnet.*.id[count.index]}"
  ami           = "${var.appserver_ami}"
  instance_type = "${var.appserver_instance_type}"
  key_name      = "Mama's Bakery"

  tags {
    Name = "Application Server"
  }
}

