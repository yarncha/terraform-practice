### [Security Group] Bastion, WEB, ELB ###
resource "aws_default_security_group" "sg_main" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.sg_main_name
  }
}

resource "aws_security_group" "sg_container" {
  name        = var.sg_container_name
  description = var.sg_container_name
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Connection from LB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.10.130.0/26"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_container_name
  }
}

resource "aws_security_group" "sg_elb" {
  name        = var.sg_elb_name
  description = var.sg_elb_name
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow from My ip"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_local_ip]
  }

  ingress {
    description = "Allow from My ip"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.my_local_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_elb_name
  }
}

### [ALB (Application Load Balancer)] elb, target groups ###
resource "aws_alb" "ecs_elb" {
  name            = var.alb_name
  internal        = false
  security_groups = [aws_security_group.sg_elb.id]
  subnets         = [aws_subnet.subnet_pub_a.id, aws_subnet.subnet_pub_c.id]

  tags = {
    Name = var.alb_name
  }
}

resource "aws_alb_target_group" "tgp_web_80" {
  name        = var.tgp_http80_name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    path                = var.health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 4
    interval            = 5
    matcher             = "200-399"
  }

  tags = {
    Name = var.tgp_http80_name
  }
}

# ### [Connections] ELB Attaching ###
# resource "aws_alb_target_group_attachment" "tgp_web_80_web01" {
#   target_group_arn = aws_alb_target_group.tgp_web_80.arn
#   target_id        = aws_instance.ec2_web01.id
#   port             = 80
# }

### [alb listener] ###
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.ecs_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.tgp_web_80.arn
    type             = "forward"
  }
}