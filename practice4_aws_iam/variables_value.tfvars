### Common Settings ###
aws_region = "us-east-1"
key_pair   = "ojt-web"

### iam.tf ###
ec2_profile_name = "ec2-profile-con-ojt"
ec2_role_name    = "ec2-role-con-ojt"

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
sg_main_name    = "scg-con-ojt-main"
sg_bastion_name = "scg-con-ojt-bastion"
sg_web_name     = "scg-con-ojt-web"
sg_elb_name     = "scg-con-ojt-elb"
my_local_ip     = "203.248.117.37/32"


# ec2
web_ami                    = "ami-00efb90f23aa15060"
common_instance_type       = "t3a.small"
ec2_bastion_name           = "ec2-con-ojt-bastion"
ec2_web01_name             = "ec2-con-ojt-web01"
iam_instance_profile_value = "ec2-role-con-ojt"

# alb
alb_name          = "elb-con-ojt"
tgp_http80_name   = "tgp-con-ojt-http80"
tgp_https443_name = "tgp-con-ojt-https443"
health_check_path = "/index.html"
