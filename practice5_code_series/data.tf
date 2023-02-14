# data - 데이터 소스 선언, 해당 region에서 사용할 수 있는 az를 가져온다
data "aws_availability_zones" "available_zones_in_region" {}

data "aws_iam_role" "ecs_task_role" {
  name = var.ecs_task_role_name
}

data "aws_iam_role" "build_role" {
  name = var.build_service_role
}

data "aws_iam_role" "pipeline_service_role" {
  name = var.pipeline_service_role_name
}