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