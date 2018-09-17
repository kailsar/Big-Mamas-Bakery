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

### Set up subnets

resource "aws_subnet" "subnet" {
	count = 4
	vpc_id            = "${aws_vpc.mainVPC.id}"
	cidr_block        = "10.2.${count.index}.0/24"
    availability_zone = "${lookup(var.availability_zone, count.index % 2)}"

	tags {
	  Name = "${format("subnet-%s-%d", "${lookup(var.availability_zone, count.index % 2)}", count.index + 1)}"
	}
}

### Set up Bastion host

resource "aws_instance" "bastion" {
	subnet_id     = "${aws_subnet.subnet.0.id}"
	ami           = "${var.bastion_ami}"
	instance_type = "${var.bastion_instance_type}"
	tags {
		Name = "Bastion Host"
	}
}

resource "aws_eip" "bastion_ip" {
	instance = "${aws_instance.bastion.id}"
}

resource "aws_security_group" "bastion_security_group" {
	name = "Bastion Security Group"
	vpc_id = "${aws_vpc.mainVPC.id}"

	ingress {
		from_port = 0
		to_port = 22
		protocol = "TCP"
		cidr_blocks = "185.73.154.30/32"
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = -1
		cidr_blocks = "0.0.0.0/0"
	}
}

