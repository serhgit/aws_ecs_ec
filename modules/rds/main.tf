resource "aws_db_subnet_group" "aurora_db_subnet_group" {
  name       = "aurora-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name        = "${var.environment}_db_subnet_${var.cluster}_${var.instance_group}"
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }
}
resource "aws_rds_cluster" "aurora_mysql_cluster" {

  cluster_identifier = "aurora-mysql-cluster"
  db_subnet_group_name   = aws_db_subnet_group.aurora_db_subnet_group.name
  engine                 = "aurora-mysql"
  engine_mode            = "provisioned"
  database_name          = var.db_name
  master_username        = var.db_user
  master_password        = var.db_password
  vpc_security_group_ids = [var.rds_security_group_id]
  
  tags = {
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }
 skip_final_snapshot  = true
}

resource "aws_rds_cluster_instance" "aurora_mysql_cluster_instance" {
  count = var.size
  identifier         = "aurora-mysql-cluster-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_mysql_cluster.id
  instance_class     = var.instance_type
  engine             = aws_rds_cluster.aurora_mysql_cluster.engine
  engine_version     = aws_rds_cluster.aurora_mysql_cluster.engine_version

  tags = {
    Name        =  "${var.environment}_rds${count.index}_${var.cluster}_${var.instance_group}"
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }
}
