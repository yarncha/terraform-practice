# AWS provider 설정
provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "yumin_ec2_server" {
  ami           = "ami-0eddbd81024d3fbdd"
  instance_type = "t2.micro"

  tags = {
    Name = "yumin_test_server"
  }
  
  vpc_security_group_ids = [aws_security_group.yumin_sg.id]
}

resource "aws_security_group" "yumin_sg" {
  name = "yumin_server_sg"
  ingress {
    from_port = 8089
    to_port = 8089
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}