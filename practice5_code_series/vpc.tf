### [VPC] VPC를 구성하는 코드 ###
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  # DNS hostname 사용 옵션
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

### [Subnet] Subnet 8개 구성하는 코드 ###
# data - 데이터 소스 선언, 해당 region에서 사용할 수 있는 az를 가져온다
data "aws_availability_zones" "available_zones_in_region" {}

resource "aws_subnet" "subnet_pub_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_pub_a_cidr_block
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[0]

  tags = {
    Name = var.subnet_pub_a_name
  }
}

resource "aws_subnet" "subnet_pub_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_pub_c_cidr_block
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[2]

  tags = {
    Name = var.subnet_pub_c_name
  }
}

resource "aws_subnet" "subnet_ap_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_ap_a_cidr_block
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[0]

  tags = {
    Name = var.subnet_ap_a_name
  }
}

resource "aws_subnet" "subnet_ap_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_ap_c_cidr_block
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[2]

  tags = {
    Name = var.subnet_ap_c_name
  }
}

resource "aws_subnet" "subnet_db_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_db_a_cidr_block
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[0]

  tags = {
    Name = var.subnet_db_a_name
  }
}

resource "aws_subnet" "subnet_db_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_db_c_cidr_block
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[2]

  tags = {
    Name = var.subnet_db_c_name
  }
}

resource "aws_subnet" "subnet_attach_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_attach_a_cidr_block
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[0]

  tags = {
    Name = var.subnet_attach_a_name
  }
}

resource "aws_subnet" "subnet_attach_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_attach_c_cidr_block
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[2]

  tags = {
    Name = var.subnet_attach_c_name
  }
}

### [Internet Gateway] ###
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw_name
  }
}

### [Elastic IP] ###
resource "aws_eip" "nat_a" {
  vpc        = true
  depends_on = [aws_internet_gateway.vpc_igw]

  tags = {
    Name = var.eip_a_name
  }
}

resource "aws_eip" "nat_c" {
  vpc        = true
  depends_on = [aws_internet_gateway.vpc_igw]

  tags = {
    Name = var.eip_c_name
  }
}

### [Nat Gateway] ###
resource "aws_nat_gateway" "nat_gw_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.subnet_pub_a.id
  depends_on    = [aws_internet_gateway.vpc_igw]

  tags = {
    Name = var.nat_a_name
  }
}

resource "aws_nat_gateway" "nat_gw_c" {
  allocation_id = aws_eip.nat_c.id
  subnet_id     = aws_subnet.subnet_pub_c.id
  depends_on    = [aws_internet_gateway.vpc_igw]

  tags = {
    Name = var.nat_c_name
  }
}

### [Route Table] ###
# vpc의 메인 route table, 생성하지 않을 시 자동 생성됨
resource "aws_default_route_table" "route_table_pub" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = {
    Name = var.route_table_pub_name
  }
}

# 프라이빗은 nat랑 연결
resource "aws_route_table" "route_table_pri_a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_a.id
  }

  tags = {
    Name = var.route_table_pri_a_name
  }
}

resource "aws_route_table" "route_table_pri_c" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_c.id
  }

  tags = {
    Name = var.route_table_pri_c_name
  }
}

### Association ###
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.subnet_pub_a.id
  route_table_id = aws_default_route_table.route_table_pub.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.subnet_pub_c.id
  route_table_id = aws_default_route_table.route_table_pub.id
}

resource "aws_route_table_association" "private_ap_a" {
  subnet_id      = aws_subnet.subnet_ap_a.id
  route_table_id = aws_route_table.route_table_pri_a.id
}

resource "aws_route_table_association" "private_ap_c" {
  subnet_id      = aws_subnet.subnet_ap_c.id
  route_table_id = aws_route_table.route_table_pri_c.id
}

resource "aws_route_table_association" "private_db_a" {
  subnet_id      = aws_subnet.subnet_db_a.id
  route_table_id = aws_route_table.route_table_pri_a.id
}

resource "aws_route_table_association" "private_db_c" {
  subnet_id      = aws_subnet.subnet_db_c.id
  route_table_id = aws_route_table.route_table_pri_c.id
}

resource "aws_route_table_association" "private_attach_a" {
  subnet_id      = aws_subnet.subnet_attach_a.id
  route_table_id = aws_route_table.route_table_pri_a.id
}

resource "aws_route_table_association" "private_attach_c" {
  subnet_id      = aws_subnet.subnet_attach_c.id
  route_table_id = aws_route_table.route_table_pri_c.id
}

### [Security Group] Bastion, WEB, ELB ###
resource "aws_default_security_group" "sg_main" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.sg_main_name
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
  load_balancer_arn = aws_alb.elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.tgp_web_80.arn
    type             = "forward"
  }
}
