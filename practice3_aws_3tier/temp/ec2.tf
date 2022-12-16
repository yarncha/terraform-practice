### [security group] bastion, web, elb ###
resource "aws_security_group" "sg_bastion" {
  name        = "scg-con-ojt-bastion"
  description = "scg-con-ojt-bastion"
  vpc_id      = aws_vpc.vpc.id

  # inbound 오픈
  #   ingress {
  #     description = "SSH from ~~"
  #     from_port   = 22
  #     to_port     = 22
  #     protocol    = "tcp"
  #     cidr_blocks = ["본인 로컬 ip"]
  #   }

  # outbound all로 오픈
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "scg-con-ojt-bastion"
  }
}

resource "aws_security_group" "sg_web" {
  name        = "scg-con-ojt-web"
  description = "scg-con-ojt-web"
  vpc_id      = aws_vpc.vpc.id

  #   ingress {
  #     description = "SSH from Bastion"
  #     from_port   = 22
  #     to_port     = 22
  #     protocol    = "tcp"
  #     cidr_blocks = ["10.10.129.0/26"]
  #   }

  #   ingress {
  #     description = "Connection from LB"
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["10.10.129.0/26"]
  #   }

  #   ingress {
  #     description = "Connection from LB"
  #     from_port   = 443
  #     to_port     = 443
  #     protocol    = "tcp"
  #     cidr_blocks = ["10.10.129.0/26"]
  #   }

  # outbound all로 오픈
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "scg-con-ojt-web"
  }
}

resource "aws_security_group" "sg_elb" {
  name        = "scg-con-ojt-elb"
  description = "scg-con-ojt-elb"
  vpc_id      = aws_vpc.vpc.id

#   ingress {
#     description = "Connection from Browser"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Connection from Browser"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "scg-con-ojt-elb"
  }
}


### [ec2] bastion, web ###
resource "aws_instance" "ec2_bastion" {
  ami           = "ami-00efb90f23aa15060"
  instance_type = "t2.micro"
  #   subnet_id     = 
  #   private_ip    = 

  associate_public_ip_address = true

  #   iam_instance_profile = aws_iam_instance_profile.ec2profile.name
  security_groups = [aws_security_group.sg_bastion.id]
  #   key_name             = 

  #   root_block_device {
  #     volume_size = "8"
  #   }

  tags = {
    Name = "ec2-con-ojt-bastion"
  }
}

resource "aws_instance" "ec2_web01" {
  ami           = "ami-00efb90f23aa15060"
  instance_type = "t2.micro"
  #   subnet_id     = data.aws_subnet.selected-pri-web-a.id
  #   private_ip    = "10.10.129.75"

  user_data = <<-EOF
              #!/bin/bash
              /app/web/apache/bin/apachectl start
              EOF

  #   iam_instance_profile = aws_iam_instance_profile.ec2profile.name
  #   security_groups      = [aws_security_group.SCG-OJT-VPC-WEB.id]
  #   key_name             = var.key_pair

  #   root_block_device {
  #     volume_size = "8"
  #   }

  tags = {
    Name = "ec2-con-ojt-web01"
  }
}

### [ALB (Application Load Balancer)] elb, target groups ###
resource "aws_alb" "elb" {
  name            = "elb-con-ojt"
#   internal        = false
  security_groups = [aws_security_group.sg_elb.id]
#   subnets         = ["${data.aws_subnet.selected-pub-a.id}", "${data.aws_subnet.selected-pub-c.id}"]

  tags = {
    Name = "elb-con-ojt"
  }
}

# resource "aws_alb_target_group" "TGP-OJT-VPC-WEB80" {
#   name     = "TGP-OJT-VPC-WEB80"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = data.aws_vpc.ojt.id

#   health_check {
#     interval            = 30
#     path                = "/health.html"
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#   }

#   tags = {
#     Name = "TGP-OJT-VPC-WEB80"
#   }
# }

# resource "aws_alb_target_group" "TGP-OJT-VPC-WEB443" {
#   name     = "TGP-OJT-VPC-WEB443"
#   port     = 443
#   protocol = "HTTP"
#   vpc_id   = data.aws_vpc.ojt.id

#   health_check {
#     interval            = 30
#     path                = "/health.html"
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#   }

#   tags = {
#     Name = "TGP-OJT-VPC-WEB443"
#   }
# }


### [connections] alb attaching ###

# resource "aws_alb_target_group_attachment" "TGP-OJT-VPC-WEB80-WEB01" {
#   target_group_arn = aws_alb_target_group.TGP-OJT-VPC-WEB80.arn
#   target_id        = aws_instance.web01.id
#   port             = 80
# }

# resource "aws_alb_target_group_attachment" "TGP-OJT-VPC-WEB80-WEB02" {
#   target_group_arn = aws_alb_target_group.TGP-OJT-VPC-WEB80.arn
#   target_id        = aws_instance.web02.id
#   port             = 80
# }

# resource "aws_alb_target_group_attachment" "TGP-OJT-VPC-WEB443-WEB01" {
#   target_group_arn = aws_alb_target_group.TGP-OJT-VPC-WEB443.arn
#   target_id        = aws_instance.web01.id
#   port             = 443
# }

# resource "aws_alb_target_group_attachment" "TGP-OJT-VPC-WEB443-WEB02" {
#   target_group_arn = aws_alb_target_group.TGP-OJT-VPC-WEB443.arn
#   target_id        = aws_instance.web02.id
#   port             = 443
# }

# # ALB ADD LISTENER RULE
# resource "aws_alb_listener" "http" {
#   load_balancer_arn = aws_alb.elb-ojt-vpc-web.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_alb_target_group.TGP-OJT-VPC-WEB80.arn
#     type             = "forward"
#   }
# }

# resource "aws_alb_listener" "https" {
#   load_balancer_arn = aws_alb.elb-ojt-vpc-web.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = data.aws_acm_certificate.yumin_cjarch_net.arn

#   default_action {
#     target_group_arn = aws_alb_target_group.TGP-OJT-VPC-WEB443.arn
#     type             = "forward"
#   }
# }


