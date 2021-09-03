resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.environment}_ecs_instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs" {
  name = "${var.environment}_ecs_instance_profile"
  path = "/"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = aws_iam_role.ecs_instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  role       = aws_iam_role.ecs_instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}


resource "aws_iam_role" "ecs_tasks_instance_role" {
  name = "${var.environment}_ecs_tasks_instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs-tasks.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF

 inline_policy {
   name   = "${var.environment}_${var.cluster}_rds_secret_access"
   policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action   = ["ssm:GetParameters", "secretsmanager:GetSecretValue"]
          Resource = "${module.secret_manager.secret_manager_rds_arn}"
        },
        {
          Effect = "Allow",
          Action = ["ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability", "ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage"]
          Resource = "*"
        }
      ]
    })
 }
}

