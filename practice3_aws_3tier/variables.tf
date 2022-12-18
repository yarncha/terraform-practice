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

# variable "environment" {
#   type = string
# }
# variable "projectCode" {
#   type = string
# }
# # variable "role_arn" {
# #   type = string
# # }

# # VPC
# # variable "secondary_cidr_block" {
# #   type = string
# # }
# variable "secondary_cidr" {
#   type = bool
# }

# # Subnet - Loop & Data Sources
# variable "subnet1_name" {
#   type = string
# }
# variable "subnet1_cidr_block" {
#   type = string
# }

# variable "subnet2_name" {
#   type = string
# }
# variable "subnet2_cidr_block" {
#   type = string
# }

# variable "subnet3_name" {
#   type = string
# }
# variable "subnet3_cidr_block" {
#   type = string
# }

# variable "subnet4_name" {
#   type = string
# }
# variable "subnet4_cidr_block" {
#   type = string
# }

# variable "subnet5_name" {
#   type = string
# }
# variable "subnet5_cidr_block" {
#   type = string
# }

# variable "subnet6_name" {
#   type = string
# }
# variable "subnet6_cidr_block" {
#   type = string
# }

# variable "subnet7_name" {
#   type = string
# }
# variable "subnet7_cidr_block" {
#   type = string
# }

# variable "subnet8_name" {
#   type = string
# }
# variable "subnet8_cidr_block" {
#   type = string
# }

# # Internet Gateway
# variable "igw_name" {
#   type = string
# }

# # Route Table
# variable "route_table_name-main" {
#   type = string
# }

# variable "route_table_name" {
#   type = string
# }

# # EC2-----------------------
# # BASTION EC2 EIP
# variable "bastioin_eip" {
#   type = string
# }

# # BASTION EC2 ROLE
# variable "ec2_role_name" {
#   type = string
# }

# variable "key_pair" {
#   type = string
# }

# variable "common_instance_type" {
#   type = string
# }

# variable "bastion_ip" {
#   type = string
# }
