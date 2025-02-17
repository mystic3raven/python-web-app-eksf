resource "aws_ecr_repository" "repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "KMS"
  }
}

resource "aws_ecr_lifecycle_policy" "repo_policy" {
 repository = aws_ecr_repository.repo.name
 policy = jsionencode({
   rules = [{
     rulePriority = 1
     description  = "Expire untagged images after 30 days"
     selection = {
       tagStatus   = "untagged"
       countType   = "sinceImagePushed"
       countUnit   = "days"
       countNumber = 30
     }
     action = {
       type = "expire"
     }
   }]
  
  }
}
