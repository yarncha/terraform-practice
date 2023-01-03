### Elastic Container Registry ###
resource "aws_ecr_repository" "image_repo" {
  name = var.ecr_name

  image_scanning_configuration {
    scan_on_push = var.ecr_image_scan
  }

  #   encryption_configuration {
  #     encryption_type = "KMS"
  #     kms_key         = ""
  #   }
}