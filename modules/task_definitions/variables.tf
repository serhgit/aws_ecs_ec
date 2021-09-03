variable "environment" {
  description = "The name of the environment"
}

variable "cluster" {
  description = "The ECS cluster name"
}

variable "secret_manager_arn" {
  description = "ARN of the secret manager where we store secret credentials"
}

variable "iam_role_arn" {
  description = "IAM Role we assign to the task definition. Example: to give access for retrieving keys"
}
