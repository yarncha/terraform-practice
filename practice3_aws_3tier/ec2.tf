data "aws_acm_certificate" "domain_cjarch_net" {
  domain   = "*.cjarchlab.net"
  statuses = ["ISSUED"]
}

### [Security Group] Bastion, WEB, ELB ###
resource "aws_default_security_group" "sg_main" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.sg_main_name
  }
}

resource "aws_security_group" "sg_bastion" {
  name        = var.sg_bastion_name
  description = var.sg_bastion_name
  vpc_id      = aws_vpc.vpc.id

  # inbound 오픈
  ingress {
    description = "SSH from user"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_local_ip]
  }

  # outbound all로 오픈
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_bastion_name
  }
}

resource "aws_security_group" "sg_web" {
  name        = var.sg_web_name
  description = var.sg_web_name
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH from Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.130.0/26"]
  }

  ingress {
    description = "Connection from LB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.10.130.0/26"]
  }

  ingress {
    description = "Connection from LB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.10.130.0/26"]
  }

  # outbound all로 오픈
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_web_name
  }
}

resource "aws_security_group" "sg_elb" {
  name        = var.sg_elb_name
  description = var.sg_elb_name
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Connection from Browser"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_local_ip]
  }

  ingress {
    description = "Connection from Browser"
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

## [EC2] Bastion, Web ###
resource "aws_instance" "ec2_bastion" {
  ami                         = var.web_ami
  instance_type               = var.common_instance_type
  key_name                    = var.key_pair
  subnet_id                   = aws_subnet.subnet_pub_a.id
  security_groups             = [aws_security_group.sg_bastion.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  depends_on                  = [aws_internet_gateway.vpc_igw]

  tags = {
    Name = var.ec2_bastion_name
  }
}

resource "aws_instance" "ec2_web01" {
  ami                         = var.web_ami
  instance_type               = var.common_instance_type
  key_name                    = var.key_pair
  subnet_id                   = aws_subnet.subnet_ap_a.id
  security_groups             = [aws_security_group.sg_web.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              sudo su -
              rm -rf /app/web/apache/logs/httpd.pid
              /app/web/apache/bin/apachectl start
              EOF

  tags = {
    Name = var.ec2_web01_name
  }
}

### [ALB (Application Load Balancer)] elb, target groups ###
resource "aws_alb" "elb" {
  name            = var.alb_name
  internal        = false
  security_groups = [aws_security_group.sg_elb.id]
  subnets         = [aws_subnet.subnet_pub_a.id, aws_subnet.subnet_pub_c.id]

  tags = {
    Name = var.alb_name
  }
}

resource "aws_alb_target_group" "tgp_web_80" {
  name     = var.tgp_http80_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    interval            = 30
    path                = var.health_check_path
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.tgp_http80_name
  }
}

resource "aws_alb_target_group" "tgp_web_443" {
  name     = var.tgp_https443_name
  port     = 443
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    interval            = 30
    path                = var.health_check_path
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.tgp_https443_name
  }
}

### [Connections] ELB Attaching ###
resource "aws_alb_target_group_attachment" "tgp_web_80_web01" {
  target_group_arn = aws_alb_target_group.tgp_web_80.arn
  target_id        = aws_instance.ec2_web01.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "tgp_web_443_web01" {
  target_group_arn = aws_alb_target_group.tgp_web_443.arn
  target_id        = aws_instance.ec2_web01.id
  port             = 443
}

### [alb listener] ###
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.tgp_web_80.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.elb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.domain_cjarch_net.arn

  default_action {
    target_group_arn = aws_alb_target_group.tgp_web_443.arn
    type             = "forward"
  }
}
