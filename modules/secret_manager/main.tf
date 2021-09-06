resource "aws_secretsmanager_secret" "rds" {
  name = "${var.environment}_${var.cluster}_rds"
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode(var.db_details)
}

resource "aws_secretsmanager_secret_version" "bucket_name" {
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = var.bucket_name
}

