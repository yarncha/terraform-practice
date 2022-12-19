### Common Settings ###
variable "aws_region" {
  type = string
}

# variable "project_name" {
#   type = string
# }

variable "key_pair" {
  type = string
}

### iam.tf ###
variable "ec2_profile_name" {
  type = string
}

variable "ec2_role_name" {
  type = string
}

### VPC.tf ###
variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "subnet_pub_a_name" {
  type = string
}

variable "subnet_pub_a_cidr_block" {
  type = string
}

variable "subnet_pub_c_name" {
  type = string
}

variable "subnet_pub_c_cidr_block" {
  type = string
}

variable "subnet_ap_a_name" {
  type = string
}

variable "subnet_ap_a_cidr_block" {
  type = string
}

variable "subnet_ap_c_name" {
  type = string
}

variable "subnet_ap_c_cidr_block" {
  type = string
}

variable "subnet_db_a_name" {
  type = string
}

variable "subnet_db_a_cidr_block" {
  type = string
}

variable "subnet_db_c_name" {
  type = string
}

variable "subnet_db_c_cidr_block" {
  type = string
}

variable "subnet_attach_a_name" {
  type = string
}

variable "subnet_attach_a_cidr_block" {
  type = string
}

variable "subnet_attach_c_name" {
  type = string
}

variable "subnet_attach_c_cidr_block" {
  type = string
}

variable "igw_name" {
  type = string
}

variable "eip_a_name" {
  type = string
}

variable "eip_c_name" {
  type = string
}

variable "nat_a_name" {
  type = string
}

variable "nat_c_name" {
  type = string
}

variable "route_table_pub_name" {
  type = string
}

variable "route_table_pri_a_name" {
  type = string
}

variable "route_table_pri_c_name" {
  type = string
}


### EC2.tf ###
variable "sg_main_name" {
  type = string
}

variable "sg_bastion_name" {
  type = string
}

variable "sg_web_name" {
  type = string
}

variable "sg_elb_name" {
  type = string
}

variable "my_local_ip" {
  type = string
}

variable "web_ami" {
  type = string
}

variable "common_instance_type" {
  type = string
}

variable "ec2_bastion_name" {
  type = string
}

variable "ec2_web01_name" {
  type = string
}

variable "alb_name" {
  type = string
}

variable "tgp_http80_name" {
  type = string
}

variable "tgp_https443_name" {
  type = string
}

variable "health_check_path" {
  type = string
}
