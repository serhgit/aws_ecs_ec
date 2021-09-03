output "ecs_instance_sg_id" {
  value = aws_security_group.ecs_instance_sg.id
}
output "lb_target_group_web_http_arn" {
  value = aws_lb_target_group.web_lb_http_target.arn
}
