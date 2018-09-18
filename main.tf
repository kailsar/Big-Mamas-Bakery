provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

### Set up VPC

resource "aws_vpc" "mainVPC" {
  cidr_block = "${var.vpc_cidrblock}"

  tags {
    Name = "Mama's Bakery VPC"
  }
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = "${aws_vpc.mainVPC.id}"
}

resource "aws_eip" "nat_elastic_ip" {
  count = "${length(var.availability_zone)}"
}

resource "aws_nat_gateway" "my_nat_gateway" {
  count         = "${length(var.availability_zone)}"
  allocation_id = "${aws_eip.nat_elastic_ip.*.id[count.index]}"
  subnet_id     = "${aws_subnet.subnet.*.id[count.index]}"
}

### Set up subnets

resource "aws_subnet" "subnet" {
  count             = "${length(var.availability_zone) * 2}"
  vpc_id            = "${aws_vpc.mainVPC.id}"
  cidr_block        = "${cidrsubnet ("${aws_vpc.mainVPC.cidr_block}", 8, count.index)}"
  availability_zone = "${lookup(var.availability_zone, count.index % "${length(var.availability_zone)}")}"

  tags {
    Name = "${format("subnet-%s-%d", "${lookup(var.availability_zone, count.index % 2)}", count.index + 1)}"
  }
}

### Set up Bastion host

resource "aws_instance" "bastion" {
  subnet_id     = "${aws_subnet.subnet.0.id}"
  ami           = "${var.bastion_ami}"
  instance_type = "${var.bastion_instance_type}"
  key_name      = "Mama's Bakery"

  tags {
    Name = "Bastion Host"
  }
}

resource "aws_eip" "bastion_ip" {
  instance = "${aws_instance.bastion.id}"
}

resource "aws_security_group" "bastion_security_group" {
  name   = "Bastion Security Group"
  vpc_id = "${aws_vpc.mainVPC.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["185.73.154.30/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "web_server" {
  count         = "${length(var.availability_zone)}"
  subnet_id     = "${aws_subnet.subnet.*.id["${length(var.availability_zone) + count.index}"]}"
  ami           = "${var.webserver_ami}"
  instance_type = "${var.webserver_instance_type}"
  key_name      = "Mama's Bakery"

  tags {
    Name = "Web Server"
  }
}

resource "aws_instance" "app_server" {
  count         = "${length(var.availability_zone)}"
  subnet_id     = "${aws_subnet.subnet.*.id["${length(var.availability_zone) + count.index}"]}"
  ami           = "${var.appserver_ami}"
  instance_type = "${var.appserver_instance_type}"
  key_name      = "Mama's Bakery"

  tags {
    Name = "Application Server"
  }
}

