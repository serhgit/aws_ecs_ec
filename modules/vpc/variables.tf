variable "vpc_cidr" {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for VPC"
}
variable "private_subnets" {
  description = "VPC private subnets"
}

variable "environment" {
  description = "The name of the environment"
}

variable "depends_id" {}
