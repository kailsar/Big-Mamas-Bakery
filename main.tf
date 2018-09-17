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

resource "aws_subnet" "subnet_az1" {
	count = 2
	vpc_id            = "${aws_vpc.mainVPC.id}"
	cidr_block        = "10.2.${count.index}.0/24"
    availability_zone = "${var.availability_zone_1}"

	tags {
	  Name = "${format("subnet_az1", count.index + 1)}"
	}
}

resource "aws_subnet" "subnet_az2" {
	count = 2
	vpc_id            = "${aws_vpc.mainVPC.id}"
	cidr_block        = "10.2.${count.index + 2}.0/24"
    availability_zone = "${var.availability_zone_2}"

	tags {
	  Name = "${format("subnet_az2", count.index + 1)}"
	}
}


