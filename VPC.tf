### Set up VPC

resource "aws_vpc" "mainVPC" {
  cidr_block = "${var.vpc_cidrblock}"

  tags {
    Name = "Mama's Bakery VPC"
  }
}

### Elastic IPs and Gateways

resource "aws_eip" "bastion_ip" {
  instance = "${aws_instance.bastion.id}"
}
resource "aws_eip" "nat_elastic_ip" {
  count = "${length(var.availability_zone)}"
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = "${aws_vpc.mainVPC.id}"
}

resource "aws_nat_gateway" "my_nat_gateway" {
  count         = "${length(var.availability_zone)}"
  allocation_id = "${aws_eip.nat_elastic_ip.*.id[count.index]}"
  subnet_id     = "${aws_subnet.public_subnet.*.id[count.index]}"
}

### Set up subnets

resource "aws_default_subnet" "public_subnet" {
  count             = "${length(var.availability_zone)}"
  availability_zone = "${lookup(var.availability_zone, count.index)}"
  tags {
    Name = "${format("public_subnet-%s", "${lookup(var.availability_zone, count.index)}")}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = "${length(var.availability_zone)}"
  vpc_id            = "${aws_vpc.mainVPC.id}"
  cidr_block        = "${cidrsubnet ("${aws_vpc.mainVPC.cidr_block}", "${var.CIDR_divider}", "${length(var.availability_zone) + count.index}")}"
# Gives a unique CIDR for each subnet, a CIDR_divider of 8 will split a /16 in to /24s
  availability_zone = "${lookup(var.availability_zone, count.index)}"
  tags {
    Name = "${format("private_subnet-%s", "${lookup(var.availability_zone, count.index)}")}"
  }
}