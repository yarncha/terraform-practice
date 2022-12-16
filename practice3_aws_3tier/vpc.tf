### [VPC] VPC를 구성하는 코드 ###
resource "aws_vpc" "vpc" {
  cidr_block = "10.10.130.0/24"

  # DNS hostname 사용 옵션
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-con-ojt"
  }
}

### [Subnet] Subnet 8개 구성하는 코드 ###
# data - 데이터 소스 선언, 해당 region에서 사용할 수 있는 az를 가져옴
data "aws_availability_zones" "available_zones_in_region" {}

resource "aws_subnet" "subnet_pub_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.10.130.0/27"
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[0]

  tags = {
    Name = "sbn-con-ojt-pub-a"
  }
}

resource "aws_subnet" "subnet_pub_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.10.130.32/27"
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[2]

  tags = {
    Name = "sbn-con-ojt-pub-c"
  }
}

resource "aws_subnet" "subnet_ap_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.10.130.64/26"
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[0]

  tags = {
    Name = "sbn-con-ojt-ap-pri-a"
  }
}
resource "aws_subnet" "subnet_ap_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.10.130.128/26"
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[2]

  tags = {
    Name = "sbn-con-ojt-ap-pri-c"
  }
}
resource "aws_subnet" "subnet_db_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.10.130.192/28"
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[0]

  tags = {
    Name = "sbn-con-ojt-db-pri-a"
  }
}
resource "aws_subnet" "subnet_db_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.10.130.208/28"
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[2]

  tags = {
    Name = "sbn-con-ojt-db-pri-c"
  }
}
resource "aws_subnet" "subnet_attach_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.10.130.224/28"
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[0]

  tags = {
    Name = "sbn-con-ojt-attach-pri-a"
  }
}
resource "aws_subnet" "subnet_attach_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.10.130.240/28"
  availability_zone = data.aws_availability_zones.available_zones_in_region.names[2]

  tags = {
    Name = "sbn-con-ojt-attach-pri-c"
  }
}

### [Internet Gateway] VPC에 igw연결 ###
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-con-ojt"
  }
}

### [Elastic IP] ###
resource "aws_eip" "nat" {
#   vpc = true
  tags = {
    Name = "eip-con-ojt"
  }
}

### [Nat Gateway] ###
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet_pub_a.id
  depends_on    = [aws_internet_gateway.vpc_igw]

  tags = {
    Name = "nat-con-ojt"
  }
}

### [Route Table] ###
resource "aws_route_table" "route_table_pub" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "rt-con-ojt-pub"
  }
}
# resource "aws_route_table" "route_table" {
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.vpc_igw.id
#   }

#   tags = {
#     Name = var.route_table_name
#   }
# }
resource "aws_route_table" "route_table_pri_a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "rt-con-ojt-pri-a"
  }
}
resource "aws_route_table" "route_table_pri_c" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "rt-con-ojt-pri-c"
  }
}


### Association ###
# resource "aws_main_route_table_association" "mainasso" {
#   vpc_id         = aws_vpc.vpc.id
#   route_table_id = aws_route_table.rtmain.id
# }

# resource "aws_route_table_association" "public-a" {
#   subnet_id      = aws_subnet.subnet1.id
#   route_table_id = aws_route_table.route_table.id
# }

# resource "aws_route_table_association" "public-c" {
#   subnet_id      = aws_subnet.subnet2.id
#   route_table_id = aws_route_table.route_table.id
# }

# resource "aws_route_table_association" "private-web-a" {
#   subnet_id      = aws_subnet.subnet3.id
#   route_table_id = aws_route_table.rtmain.id
# }

# resource "aws_route_table_association" "private-web-c" {
#   subnet_id      = aws_subnet.subnet4.id
#   route_table_id = aws_route_table.rtmain.id
# }

# resource "aws_route_table_association" "private-was-a" {
#   subnet_id      = aws_subnet.subnet5.id
#   route_table_id = aws_route_table.rtmain.id
# }

# resource "aws_route_table_association" "private-was-c" {
#   subnet_id      = aws_subnet.subnet6.id
#   route_table_id = aws_route_table.rtmain.id
# }

# resource "aws_route_table_association" "private-db-a" {
#   subnet_id      = aws_subnet.subnet7.id
#   route_table_id = aws_route_table.rtmain.id
# }

# resource "aws_route_table_association" "private-db-c" {
#   subnet_id      = aws_subnet.subnet8.id
#   route_table_id = aws_route_table.rtmain.id
# }