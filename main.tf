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

resource "aws_subnet" "subnet_az1_public" {
	vpc_id            = "${aws_vpc.mainVPC.id}"
	cidr_block        = "${var.subnet_az1_public_cidrblock}"
    availability_zone = "${var.availability_zone_1}"

	tags {
	  Name = "subnet_az1_public"
	}
}

resource "aws_subnet" "subnet_az1_private" {
	vpc_id            = "${aws_vpc.mainVPC.id}"
	cidr_block        = "${var.subnet_az1_private_cidrblock}"
    availability_zone = "${var.availability_zone_1}"

	tags {
	  Name = "subnet_az1_private"
	}
}

resource "aws_subnet" "subnet_az2_public" {
	vpc_id            = "${aws_vpc.mainVPC.id}"
	cidr_block        = "${var.subnet_az2_public_cidrblock}"
    availability_zone = "${var.availability_zone_2}"
	
	tags {
	  Name = "subnet_az2_public"
	}
}

resource "aws_subnet" "subnet_az2_private" {
	vpc_id            = "${aws_vpc.mainVPC.id}"
	cidr_block        = "${var.subnet_az2_private_cidrblock}"
    availability_zone = "${var.availability_zone_2}"

	tags {
	  Name = "subnet_az2_private"
	}
}

