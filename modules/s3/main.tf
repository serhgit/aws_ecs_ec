resource "aws_s3_bucket" "bucket_apache_php" {
  bucket = "${var.environment}-apache-php"
  acl    = "private"

  tags = {
    Name        = "${var.environment}_${var.cluster}_apache_php"
    Environment = "${var.environment}"
  }
}
