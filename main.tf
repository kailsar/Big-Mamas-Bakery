provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
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
resource "aws_rds_cluster" "RDS Cluster" {
  cluster_identifier      = "bakery-aurora-cluster"
  engine                  = "aurora-mysql"
  availability_zones      = ["${aws_subnet.private_subnet.*.id}"]
  database_name           = "mamasbakery"
  master_username         = "admin"
  master_password         = "b5GxJhWJuQkjcX2"
}