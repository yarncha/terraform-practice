### Common Settings ###
variable "aws_region" {
  type = string
}
variable "project_name" {
  type = string
}

### Elastic Container Registry ###
variable "ecr_name" {
  type = string
}
variable "ecr_image_scan" {
  type = string
}

### Code Commit ###
variable "repo_name" {
  type = string
}
variable "default_branch" {
  type = string
}
variable "repo_description" {
  type = string
}

### Code Build ###
variable "build_project_name" {
  type = string
}
variable "build_service_role" {
  type = string
}
variable "build_project_description" {
  type = string
}
variable "build_provider" {
  type = string
}
variable "build_env_compute_type" {
  type = string
}
variable "build_image" {
  type = string
}
variable "build_type" {
  type = string
}
variable "build_is_privileged_mode" {
  type = string
}
variable "build_credentials_type" {
  type = string
}
variable "build_artifacts_type" {
  type = string
}
variable "build_cloudwatch_log_status" {
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
variable "sg_elb_name" {
  type = string
}
variable "my_local_ip" {
  type = string
}
variable "alb_name" {
  type = string
}
variable "tgp_http80_name" {
  type = string
}
variable "health_check_path" {
  type = string
}