### Common Settings ###
aws_region   = "ap-northeast-1"
project_name = "con-ojt"

### Elastic Container Registry ###
ecr_name       = "ecr-con-ojt"
ecr_image_scan = false

### Code Commit ###
repo_name        = "repo-con-ojt-ecs"
default_branch   = "main"
repo_description = "Application repo for lambda"

### IAM ###


### Code Build ###
build_project_name          = "pjt-con-ojt-ecs"
build_service_role          = "pjt-con-ojt-service-role"
build_project_description   = "Code Build Project"
build_provider              = "CODECOMMIT"
build_env_compute_type      = "BUILD_GENERAL1_MEDIUM"
build_image                 = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
build_type                  = "LINUX_CONTAINER"
build_is_privileged_mode    = true
build_credentials_type      = "CODEBUILD"
build_artifacts_type        = "NO_ARTIFACTS"
build_cloudwatch_log_status = "ENABLED"


### VPC.tf ###
# vpc
vpc_name       = "vpc-con-ojt"
vpc_cidr_block = "10.10.130.0/24"

# subnet
subnet_pub_a_name          = "sbn-con-ojt-pub-a"
subnet_pub_a_cidr_block    = "10.10.130.0/27"
subnet_pub_c_name          = "sbn-con-ojt-pub-c"
subnet_pub_c_cidr_block    = "10.10.130.32/27"
subnet_ap_a_name           = "sbn-con-ojt-ap-pri-a"
subnet_ap_a_cidr_block     = "10.10.130.64/26"
subnet_ap_c_name           = "sbn-con-ojt-ap-pri-c"
subnet_ap_c_cidr_block     = "10.10.130.128/26"
subnet_db_a_name           = "sbn-con-ojt-db-pri-a"
subnet_db_a_cidr_block     = "10.10.130.192/28"
subnet_db_c_name           = "sbn-con-ojt-db-pri-c"
subnet_db_c_cidr_block     = "10.10.130.208/28"
subnet_attach_a_name       = "sbn-con-ojt-attach-pri-a"
subnet_attach_a_cidr_block = "10.10.130.224/28"
subnet_attach_c_name       = "sbn-con-ojt-attach-pri-c"
subnet_attach_c_cidr_block = "10.10.130.240/28"

# Internet GateWay
igw_name = "igw-con-ojt"

# Elastic IP
eip_a_name = "eip-con-ojt-a"
eip_c_name = "eip-con-ojt-c"

# Nat Gateway
nat_a_name = "nat-con-ojt_a"
nat_c_name = "nat-con-ojt_c"

# Route table
route_table_pub_name   = "rt-con-ojt-pub"
route_table_pri_a_name = "rt-con-ojt-pri-a"
route_table_pri_c_name = "rt-con-ojt-pri-c"

### EC2.tf ###
# sg
sg_main_name = "scg-con-ojt-main"
sg_elb_name  = "scg-con-ojt-elb"

# alb
alb_name          = "elb-con-ojt"
tgp_http80_name   = "tgp-con-ojt-http80"
health_check_path = "/index.html"
