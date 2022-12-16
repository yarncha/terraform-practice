# [VPC] VPC를 구성하는 코드
resource "aws_vpc" "vpc" {
  cidr_block = "10.10.130.0/24"

  # DNS hostname 사용 옵션
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-con-ojt"
  }
}

# [Subnet] Subnet 8개 구성하는 코드
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

# [Internet Gateway] VPC에 igw연결
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "sbn-con-ojt-igw"
  }
}

# [Elastic IP]
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "sbn-con-ojt-eip"
  }
}

# [Nat Gateway]
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet_pub_a.id
  depends_on    = [aws_internet_gateway.vpc_igw]

  tags = {
    Name = "sbn-con-ojt-nat"
  }
}

# Route Table
