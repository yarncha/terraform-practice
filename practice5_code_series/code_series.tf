### Code Commit ###
resource "aws_codecommit_repository" "codecommit_repository" {
  repository_name = var.repo_name
  default_branch  = var.default_branch
  description     = var.repo_description

  tags = {
    name = var.repo_name
  }
}

output "git_clone_url" {
  value = aws_codecommit_repository.codecommit_repository.clone_url_http
}

### Code Build ###
resource "aws_codebuild_project" "codebuild" {
  name         = var.build_project_name
  service_role = data.aws_iam_role.build_role.arn
  description  = var.build_project_description

  source {
    type     = var.build_provider
    location = aws_codecommit_repository.codecommit_repository.clone_url_http
  }

  environment {
    compute_type                = var.build_env_compute_type
    image                       = var.build_image
    type                        = var.build_type
    privileged_mode             = var.build_is_privileged_mode
    image_pull_credentials_type = var.build_credentials_type
  }

  artifacts {
    type = var.build_artifacts_type
  }

  logs_config {
    cloudwatch_logs {
      status = var.build_cloudwatch_log_status
    }
  }

  tags = {
    name = var.build_project_name
  }
}

### Code Pipeline ###
resource "aws_codepipeline" "aws_codepipeline" {
  name     = var.pipeline_name
  role_arn = data.aws_iam_role.pipeline_service_role.arn

  artifact_store {
    location = data.aws_s3_bucket.pipeline_s3.id
    type     = var.pipeline_artifact_type

    encryption_key {
      id   = var.pipeline_encryption_key
      type = var.pipeline_encryption_type
    }
  }

  stage {
    name = "Source"

    action {
      name             = var.source_stage_name
      category         = "Source"
      owner            = var.source_stage_provider_owner
      version          = "1"
      provider         = var.source_stage_provider
      run_order        = 1
      namespace        = "SourceVariables"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName       = aws_codecommit_repository.codecommit_repository.id
        BranchName           = var.source_stage_branch_name
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = var.build_stage_name
      category         = "Build"
      owner            = var.build_stage_provider_owner
      provider         = var.build_stage_provider
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact_server"]

      configuration = {
        ProjectName = aws_codebuild_project.codebuild.id
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = var.deploy_stage_name
      category        = "Deploy"
      owner           = var.deploy_stage_provider_owner
      provider        = var.deploy_stage_provider
      input_artifacts = ["BuildArtifact_server"]
      version         = "1"

      configuration = {
        ClusterName = aws_ecs_cluster.ecs_cluster.id
        ServiceName = aws_ecs_service.ecs_service.id
        FileName    = var.deploy_stage_configuration_filename
      }
    }
  }
}