resource "aws_ecs_task_definition" "apache_php_rds" {
  family                   = "${var.environment}_${var.cluster}_apache_php_rds"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = "${var.iam_role_arn}"
  cpu    = "1024"
  memory = "400"
  container_definitions = jsonencode([
    {
      name      = "apache_php_rds"
      image     = "288946686376.dkr.ecr.us-east-1.amazonaws.com/apache_php_rds:5.0"
      cpu       = 500
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      secrets = [ 
        {
          name             = "db_details"
          valueFrom        = "${var.secret_manager_arn}"
        },
        {
          name             = "bucket_name"
          valueFrom        = "${var.secret_manager_arn}"
        }
      ]
    }
  ])

  tags = {
    Name        = "${var.environment}_${var.cluster}_apache_php_rds"
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }
}
