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