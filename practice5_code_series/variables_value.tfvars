### main.tf ###
aws_region = "XXXXXX"

### data.tf ###
build_service_role         = "iam-role-con-ojt-codebuild-project"
ecs_task_role_name         = "iam-role-con-ojt-ecs-task"
pipeline_service_role_name = "iam-role-con-ojt-codepipeline"

### s3.tf ###
s3_name                    = "s3-con-ojt-pipeline-XXXXXX"

### vpc.tf ###
# vpc
vpc_name       = "vpc-con-ojt"
vpc_cidr_block = "10.10.130.0/24"

# subnet
subnet_pub_a_name          = "sbn-con-ojt-pub-a"
subnet_pub_a_cidr_block    = "10.10.130.0/27"
subnet_pub_c_name          = "sbn-con-ojt-pub-c"
subnet_pub_c_cidr_block    = "10.10.130.32/27"
subnet_ap_a_name           = "sbn-con-ojt-ap-pri-a"
subnet_ap_a_cidr_block     = "10.10.130.64/27"
subnet_ap_c_name           = "sbn-con-ojt-ap-pri-c"
subnet_ap_c_cidr_block     = "10.10.130.96/27"
subnet_db_a_name           = "sbn-con-ojt-db-pri-a"
subnet_db_a_cidr_block     = "10.10.130.128/27"
subnet_db_c_name           = "sbn-con-ojt-db-pri-c"
subnet_db_c_cidr_block     = "10.10.130.160/27"
subnet_attach_a_name       = "sbn-con-ojt-attach-pri-a"
subnet_attach_a_cidr_block = "10.10.130.192/27"
subnet_attach_c_name       = "sbn-con-ojt-attach-pri-c"
subnet_attach_c_cidr_block = "10.10.130.224/27"

# Internet GateWay
igw_name = "igw-con-ojt"

# Elastic IP
eip_a_name = "eip-con-ojt-a"
eip_c_name = "eip-con-ojt-c"

# Nat Gateway
nat_a_name = "nat-con-ojt-a"
nat_c_name = "nat-con-ojt-c"

# Route table
route_table_pub_name   = "rt-con-ojt-pub"
route_table_pri_a_name = "rt-con-ojt-pri-a"
route_table_pri_c_name = "rt-con-ojt-pri-c"

### EC2.tf ###
# sg
sg_main_name      = "scg-con-ojt-main"
sg_container_name = "scg-con-ojt-container"
sg_elb_name       = "scg-con-ojt-elb"
my_local_ip       = "XXX.XXX.XXX.XXX/32"

# alb
alb_name          = "elb-con-ojt"
tgp_http80_name   = "tgp-con-ojt-http80"
health_check_path = "/"


### Elastic Container Registry ###
ecr_name       = "ecr-con-ojt"
ecr_image_scan = false


### Elastic Container Service ###
# Task Definition
task_definition_name             = "td-con-ojt"
task_definition_network_mode     = "awsvpc"
task_definition_type             = "FARGATE"
task_definition_cpu              = 256
task_definition_memory           = 512
task_definition_container_name   = "con-con-ojt"
task_definition_container_cpu    = 128
task_definition_container_memory = 128
task_definition_port             = 80
task_definition_operation_system = "LINUX"
task_definition_cpu_architecture = "X86_64"

# Cluster
cluster_name = "cst-con-ojt"

# ECS Service
service_name                = "svc-con-ojt"
service_launch_type         = "FARGATE"
service_scheduling_strategy = "REPLICA"
service_desired_count       = 2
service_health_check_period = 0
service_assign_public_ip    = false
service_deployment          = "ECS"


### Code Series ###
# Code Commit
repo_name        = "repo-con-ojt-ecs"
default_branch   = "master"
repo_description = "Application repo for lambda"

# Code Build
build_project_name          = "pjt-con-ojt-ecs"
build_project_description   = "Code Build Project"
build_provider              = "CODECOMMIT"
build_env_compute_type      = "BUILD_GENERAL1_MEDIUM"
build_image                 = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
build_type                  = "LINUX_CONTAINER"
build_is_privileged_mode    = true
build_credentials_type      = "CODEBUILD"
build_artifacts_type        = "NO_ARTIFACTS"
build_cloudwatch_log_status = "ENABLED"

# Code Pipeline
pipeline_name                       = "ppl-con-ojt"
pipeline_artifact_type              = "S3"
pipeline_encryption_type            = "KMS"
source_stage_name                   = "Source"
source_stage_provider               = "CodeCommit"
source_stage_provider_owner         = "AWS"
source_stage_branch_name            = "master"
build_stage_name                    = "Build_server"
build_stage_provider                = "CodeBuild"
build_stage_provider_owner          = "AWS"
deploy_stage_name                   = "Deploy_server"
deploy_stage_provider               = "ECS"
deploy_stage_provider_owner         = "AWS"
deploy_stage_configuration_filename = "imagedefinitions.json"