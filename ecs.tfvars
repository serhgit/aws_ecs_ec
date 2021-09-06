#Environment
environment = "dev"

#AWS CLI Profile
aws_profile = "default"

#AWS region where we create resources
aws_region = "us-east-1"

#AWS ECS instances AMI
aws_ecs_ami = ""

#VPC CIDR
vpc_cidr = "10.0.0.0/16"

#Private IP ranges
private_subnets = ["10.0.200.0/24", "10.0.201.0/24"]

#AWS availability zones to create subnets in
availability_zones = ["us-east-1a", "us-east-1b"]

# Maximum number of instances in the ECS cluster.
max_size = 3

# Minimum number of instances in the ECS cluster.
min_size = 2

# Ideal number of instances in the ECS cluster.
desired_capacity = 3

# Size of instances in the ECS cluster.
instance_type = "t2.micro"

db_user     = "test_user"
db_password = "gfhjkmgfhjkm"
db_name     = "test_db"
