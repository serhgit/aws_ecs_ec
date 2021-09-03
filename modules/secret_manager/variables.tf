variable "environment" {
  description = "The name of the environment"
}

variable "cluster" {
  description = "The ECS cluster name"
}

#variable "db_user" {
# description = "DB username"
#}
#variable "db_password" {
# description = "DB password"
#}
#variable "db_name" {
#  description = "DB name"
#}

variable "db_details" {
   type = map(string)
}
