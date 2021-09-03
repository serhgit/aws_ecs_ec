output "db_write_host" {
  value = aws_rds_cluster.aurora_mysql_cluster.endpoint
}
