data "aws_ami" "latest_ecs_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}


resource "aws_security_group" "ecs_instance_sg" {
  name        = "${var.environment}_${var.cluster}_${var.instance_group}"
  description = "Allow all ingress traffic"
  vpc_id      = var.vpc_id

  ingress =[
    {
      description = "Allow ingress traffic"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]

  egress = [
    {
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true

    }
  ]
}

resource "aws_launch_template" "ec2_ecs_launch" {
  name_prefix          = "${var.environment}_${var.cluster}_${var.instance_group}_"
  instance_type        = var.instance_type
  image_id             = var.aws_ami != "" ? var.aws_ami : data.aws_ami.latest_ecs_ami.image_id
  key_name             = var.key_name
  user_data            = base64encode(data.template_file.user_data.rendered)
  iam_instance_profile {
    arn = var.iam_instance_profile_arn
  }
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  network_interfaces {

    associate_public_ip_address = true

    #We need to associate the security group with the network interface
    #otherwise the template becomes incomplete (not-full template)
    security_groups = [aws_security_group.ecs_instance_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_ecs" {
  name = "${var.environment}_${var.cluster}_${var.instance_group}"

  #We should use vpc_zone_identifier instead of availability_zones
  #otherwise the instances are created in the default VPC
  #That causes the conflict as our secuity groups might be
  #in non-default VPC
  vpc_zone_identifier = var.private_subnet_ids

  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size
  force_delete     = true

  launch_template {
    id = aws_launch_template.ec2_ecs_launch.id
    version = "$Latest"
  }

  health_check_type = "EC2"

  tag {
    key                 = "Name"
    value               = "${var.environment}_ecs_${var.cluster}_${var.instance_group}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Cluster"
    value               = var.cluster
    propagate_at_launch = "true"
  }

  tag {
    key                 = "InstanceGroup"
    value               = var.instance_group
    propagate_at_launch = "true"
  }
}


resource "aws_lb" "web_lb" {
  name               = "${var.environment}-${var.cluster}-web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_instance_sg.id]
  subnets            = var.private_subnet_ids


  enable_deletion_protection = false

  tags = {
    Name        = "${var.environment}-${var.cluster}-web-lb"
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }
}

resource "aws_lb_target_group" "web_lb_http_target" {
  name     = "${var.environment}-${var.cluster}web-lb-http-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    Name        = "${var.environment}-${var.cluster}-web-lb"
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }
}
resource "aws_lb_listener" "web_lb_http" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_lb_http_target.arn
  }
}


data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh")}"

  vars = {
    ecs_config        = var.ecs_config
#    ecs_logging       = var.ecs_logging
    cluster_name      = var.cluster
    environment       = var.environment
    custom_userdata   = var.custom_userdata
#    cloudwatch_prefix = var.cloudwatch_prefix
  }
}

