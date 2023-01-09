# # pipeline s3
# resource "aws_s3_bucket" "pipeline_bucket" {
#   bucket = "s3-con-ojt-pipeline"

#   tags = {
#     bucket = "s3-con-ojt-pipeline"
#   }
# }

# resource "aws_s3_bucket_acl" "pipeline_bucket_acl" {
#   bucket = aws_s3_bucket.pipeline_bucket.id
#   acl    = "private"
# }
