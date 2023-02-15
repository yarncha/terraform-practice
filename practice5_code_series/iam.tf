# # codebuild service role
# resource "aws_iam_role" "build_service_role" {
#   name                  = "iam-role-con-ojt-codebuild-project"
#   description           = "IAM Role for Codebuild project"
#   force_detach_policies = true

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "codebuild.amazonaws.com"
#       }
#     }
#   ]
# }
# EOF

#   tags = {
#     name = "iam-role-con-ojt-codebuild-project"
#   }
# }

# resource "aws_iam_policy" "build_service_role_policy" {
#   name        = "policy-con-ojt-codebuild-project"
#   description = "Codebuild base policy"

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Resource": [
#                 "*"
#             ],
#             "Action": [
#                 "logs:CreateLogGroup",
#                 "logs:CreateLogStream",
#                 "logs:PutLogEvents"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Resource": [
#                 "*"
#             ],
#             "Action": [
#                 "s3:PutObject",
#                 "s3:GetObject",
#                 "s3:GetObjectVersion",
#                 "s3:GetBucketAcl",
#                 "s3:GetBucketLocation"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Resource": [
#                 "*"
#             ],
#             "Action": [
#                 "codecommit:GitPull"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Resource": [
#                 "*"
#             ],
#             "Action": [
#                 "codebuild:CreateReportGroup",
#                 "codebuild:CreateReport",
#                 "codebuild:UpdateReport",
#                 "codebuild:BatchPutTestCases",
#                 "codebuild:BatchPutCodeCoverages"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Resource": "*",
#             "Action": [
#                 "ecr:GetAuthorizationToken",
#                 "ecr:BatchCheckLayerAvailability",
#                 "ecr:GetDownloadUrlForLayer",
#                 "ecr:GetRepositoryPolicy",
#                 "ecr:DescribeRepositories",
#                 "ecr:ListImages",
#                 "ecr:DescribeImages",
#                 "ecr:BatchGetImage",
#                 "ecr:GetLifecyclePolicy",
#                 "ecr:GetLifecyclePolicyPreview",
#                 "ecr:ListTagsForResource",
#                 "ecr:DescribeImageScanFindings",
#                 "ecr:InitiateLayerUpload",
#                 "ecr:UploadLayerPart",
#                 "ecr:CompleteLayerUpload",
#                 "ecr:PutImage"
#             ]
#         }
#     ]
# }
# EOF

#   tags = {
#     name = "policy-con-ojt-codebuild-project"
#   }
# }

# resource "aws_iam_role_policy_attachment" "build_role_attach" {
#   role       = aws_iam_role.build_service_role.name
#   policy_arn = aws_iam_policy.build_service_role_policy.arn
# }


# # ecs task role
# resource "aws_iam_role" "ecs_task_role" {
#   name                  = "iam-role-con-ojt-ecs-task"
#   description           = "IAM Role for ECS Task"
#   force_detach_policies = true

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Effect": "Allow",
#       "Principal": {
#       "Service": "ecs-tasks.amazonaws.com"
#       }
#     }
#   ]
# }
# EOF

#   tags = {
#     name = "iam-role-con-ojt-ecs-task"
#   }
# }

# data "aws_iam_policy" "ecs_task_role_policy" {
#   arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# resource "aws_iam_role_policy_attachment" "task_role_attach" {
#   role       = aws_iam_role.ecs_task_role.name
#   policy_arn = data.aws_iam_policy.ecs_task_role_policy.arn
# }


# # codepipeline
# resource "aws_iam_role" "pipeline_service_role" {
#   name                  = "iam-role-con-ojt-codepipeline"
#   description           = "IAM Role for CodePipeline"
#   force_detach_policies = true

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "codepipeline.amazonaws.com"
#       }
#     }
#   ]
# }
# EOF

#   tags = {
#     name = "iam-role-con-ojt-codepipeline"
#   }
# }

# resource "aws_iam_policy" "pipeline_service_role_policy" {
#   name        = "policy-con-ojt-codepipeline"
#   description = "CodePipeline base policy"

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#           "Effect": "Allow",
#           "Action": [  
#               "codecommit:GetBranch",
#               "codecommit:GetCommit",
#               "codecommit:UploadArchive",
#               "codecommit:GetUploadArchiveStatus",
#               "codecommit:CancelUploadArchive"
#                     ],
#           "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "codebuild:BatchGetBuilds",
#                 "codebuild:StartBuild"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ecr:DescribeImages"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ecs:DescribeServices",
#                 "ecs:DescribeTaskDefinition",
#                 "ecs:DescribeTasks",
#                 "ecs:ListTasks",
#                 "ecs:RegisterTaskDefinition",
#                 "ecs:UpdateService"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": "iam:PassRole",
#             "Resource": [
#                 "${aws_iam_role.ecs_task_role.arn}"
#             ]
#         },
#         {
#             "Sid": "CodePipelineArtifactBucketAccess",
#             "Effect": "Allow",
#             "Action": [
#                 "s3:PutObject",
#                 "s3:GetBucketVersioning",
#                 "s3:ListObjects",
#                 "s3:ListBucket",
#                 "s3:GetObjectVersion",
#                 "s3:GetObject",
#                 "s3:GetBucketLocation"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
# EOF

#   tags = {
#     name = "policy-con-ojt-codepipeline"
#   }
# }

# resource "aws_iam_role_policy_attachment" "pipeline_role_attach" {
#   role       = aws_iam_role.pipeline_service_role.name
#   policy_arn = aws_iam_policy.pipeline_service_role_policy.arn
# }