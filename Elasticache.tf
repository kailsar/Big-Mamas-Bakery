
resource "aws_elasticache_subnet_group" "EC_subnet_group" {
    subnet_ids = ["${aws_subnet.private_subnet.*.id}"]
    name = "${var.subnet_group_name}"
}

resource "aws_elasticache_replication_group" "default" {
  replication_group_id          = "MamasRedis"
  replication_group_description = "Redis cluster"
 
  node_type            = "cache.t2.micro"
  port                 = 6379
  parameter_group_name = "default.redis4.0.cluster.on"
 
  snapshot_retention_limit = 5
  snapshot_window          = "00:00-05:00"
 
  subnet_group_name = "${aws_elasticache_subnet_group.EC_subnet_group.name}"
 
  automatic_failover_enabled = true
 
  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = 1
  }
}
