variable "aws_region" {}
variable "aws_profile" {}

variable "vpc_cidrblock" {}

variable "availability_zone" {
  type = "map"
}

variable "bastion_ami" {}

variable "bastion_instance_type" {}
