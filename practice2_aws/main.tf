# AWS provider 설정
provider "aws" {
  region = "ap-northeast-2"
}

# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.10.129.0/24"

  tags = {
    Name = "yumin-vpc"
  }
}

# Subnet(public*2, private*6)
resource "aws_subnet" "first_subnet" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "yumin-vpc-pub-a"
  }
}


resource "aws_subnet" "second_subnet" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "101subnet-2"
  }
}

# igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "main"
  }
}

# route table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.first_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_2" {
  subnet_id      = aws_subnet.second_subnet.id
  route_table_id = aws_route_table.route_table.id
}

# private subnet
resource "aws_subnet" "first_private_subnet" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = "10.0.3.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "101subnet-private-1"
  }
}

resource "aws_subnet" "second_private_subnet" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = "10.0.4.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "101subnet-private-2"
  }
}

# nat gw
resource "aws_eip" "nat_1" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "nat_2" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_1.id

  # Private subnet이 아니라 public subnet을 연결하셔야 합니다.
  subnet_id = aws_subnet.first_subnet.id

  tags = {
    Name = "NAT-GW-1"
  }
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_2.id

  subnet_id = aws_subnet.second_subnet.id

  tags = {
    Name = "NAT-GW-2"
  }
}

# route table 연결
resource "aws_route_table" "route_table_private_1" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "main-private-1"
  }
}

resource "aws_route_table" "route_table_private_2" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "main-private-2"
  }
}

resource "aws_route_table_association" "route_table_association_private_1" {
  subnet_id      = aws_subnet.first_private_subnet.id
  route_table_id = aws_route_table.route_table_private_1.id
}

resource "aws_route_table_association" "route_table_association_private_2" {
  subnet_id      = aws_subnet.second_private_subnet.id
  route_table_id = aws_route_table.route_table_private_2.id
}

resource "aws_route" "private_nat_1" {
  route_table_id              = aws_route_table.route_table_private_1.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.nat_gateway_1.id
}

resource "aws_route" "private_nat_2" {
  route_table_id              = aws_route_table.route_table_private_2.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.nat_gateway_2.id
}