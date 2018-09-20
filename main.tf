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
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  multi_az             = true
  name                 = "mamas_rds"
  username             = "admin"
  password             = "9aDrG}GK$>[#E4A"
  parameter_group_name = "default.mysql5.7"
  storage_encrypted    = true
}
