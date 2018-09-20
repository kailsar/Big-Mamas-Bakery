resource "aws_route_table" "private_route_table" {
  count = "${length(var.availability_zone)}"
  vpc_id = "${aws_vpc.mainVPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.my_nat_gateway.*.id[count.index]}"
  }
}
 
 resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.mainVPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_internet_gateway.id}"
  }
}

resource "aws_route_table_association" "private_route_table" {
  count          = "${length(var.availability_zone)}"
  subnet_id      = "${aws_subnet.private_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.private_route_table.*.id[count.index]}"
}

resource "aws_route_table_association" "public_route_table" {
  count          = "${length(var.availability_zone)}"
  subnet_id      = "${aws_subnet.public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}
