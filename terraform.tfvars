aws_profile = "default"
aws_region = "eu-west-1"

vpc_cidrblock = "10.2.0.0/16"

CIDR_divider = "4"

availability_zone = {
        "0" = "eu-west-1a"
        "1" = "eu-west-1b"
    }
bastion_ami = "ami-047bb4163c506cd98"

bastion_instance_type = "t2.micro"

webserver_ami = "ami-047bb4163c506cd98"

webserver_instance_type = "t2.micro"

appserver_ami = "ami-047bb4163c506cd98"

appserver_instance_type = "t2.micro"

subnet_group_name = "elasticacheSG"
