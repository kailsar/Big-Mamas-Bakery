
resource "aws_elasticache_subnet_group" "EC_subnet_group" {
    subnet_ids = ["${aws_subnet.private_subnet.*.id}"]
}