variable "environment" {
  description = "The name of the environment"
}

variable "cluster" {
  description = "The RDS cluster name"
}

variable "instance_type" {
  default     = "db.r5.large"
  description = "AWS instance type to use for RDS"
}

variable "instance_group" {
  default     = "default"
  description = "The name of the instances that you consider as a group"
}


variable "size" {
  description = "Size of the nodes in the RDS cluster"
}

variable "rds_security_group_id" {
  description = "Security group we want to assign to RDS cluster"
}
variable "db_subnet_ids" {
  type        = list
  description = "List of rds subnet ids, we put into db subnet group"
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
