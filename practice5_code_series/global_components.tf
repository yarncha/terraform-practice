data "aws_iam_role" "build_role" {
  name = var.build_service_role
}

data "aws_iam_role" "ecs_task_role" {
  name = var.ecs_task_role_name
}

data "aws_iam_role" "pipeline_service_role" {
  name = var.pipeline_service_role_name
}

data "aws_s3_bucket" "pipeline_s3" {
  bucket = var.s3_name
}

# resource "aws_iam_policy" "codebuild_policy" {
#   description = "CodeBuild Execution Policy"
#   policy      = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents",
#         "ecr:GetAuthorizationToken"
#       ],
#       "Effect": "Allow",
#       "Resource": "*"
#     },
#     {
#       "Action": [
#         "s3:GetObject", "s3:GetObjectVersion", "s3:PutObject"
#       ],
#       "Effect": "Allow",
#       "Resource": "${aws_s3_bucket.artifact_bucket.arn}/*"
#     },
#     {
#       "Action": [
#         "ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage",
#         "ecr:BatchCheckLayerAvailability", "ecr:PutImage",
#         "ecr:InitiateLayerUpload", "ecr:UploadLayerPart",
#         "ecr:CompleteLayerUpload"
#       ],
#       "Effect": "Allow",
#       "Resource": "${aws_ecr_repository.image_repo.arn}"
#     }
#   ]
# }
# EOF
# }
