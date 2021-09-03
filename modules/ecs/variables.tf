variable "environment" {
  description = "The name of the environment"
}

variable "cluster" {
  description = "The ECS cluster name"
}
variable "key_name" {
  description = "Key we use for the ECS instances"
}

variable "instance_type" {
  description = "AWS instance type to use"
}

variable "aws_ami" {
  description = "The AWS ami id to use for ECS"
}

variable "instance_group" {
  default     = "default"
  description = "The name of the instances that you consider as a group"
}

variable "vpc_cidr" {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}

variable "availability_zones" {
  type        = list
  description = "List of availability zones you want. Example: eu-west-1a and eu-west-1b"
}

variable "max_size" {
  description = "Maximum size of the nodes in the cluster"
}

variable "min_size" {
  description = "Minimum size of the nodes in the cluster"
}

variable "desired_capacity" {
  description = "The desired capacity of the cluster"
}

variable "private_subnets" {
  type        = list
  description = "List of private cidrs, for every availability zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
}

variable "db_user" {
  description = "DB username"
}
variable "db_password" {
  description = "DB password"
}
variable "db_name" {
  description = "DB name"
}
variable "ecr_apache_php_rds_arn" {
  description = "ARN for ECR repository of apache_php_rds"
}
