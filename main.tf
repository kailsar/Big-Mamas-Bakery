provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

data "aws_iam_role" "rds_iam_role" {
  name = "RDSFull"
}

resource "aws_iam_instance_profile" "rds_iam_profile" {
  name = "${var.deploy_type}_rds_profile"
  role = "${data.aws_iam_role.rds_iam_role.name}"
}

resource "aws_security_group" "bastion_security_group" {
  name   = "Bastion Security Group"
  vpc_id = "${aws_vpc.mainVPC.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["185.73.154.30/32","88.97.27.7/32","35.178.219.243/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_security_group" {
  name   = "Private Subnet Security Group"
  vpc_id = "${aws_vpc.mainVPC.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["10.2.0.0/16"]
  }
  
    ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["10.2.0.0/16"]
  }

    ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    security_groups  = ["${aws_security_group.alb_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_security_group" {
  name   = "ALB Security Group"
  vpc_id = "${aws_vpc.mainVPC.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

