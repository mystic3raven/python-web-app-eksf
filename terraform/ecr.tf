resource "aws_ecr_repository" "python_web_app" {
  name = "python-web-app-eksf"

  image_scanning_configuration {
    scan_on_push = true # 
  }

  encryption_configuration {
    encryption_type = "KMS" # 
  }

  image_tag_mutability = "IMMUTABLE" # 
  lifecycle {
    prevent_destroy = true # ✅ Ensures repository is not accidentally deleted
  }
}
