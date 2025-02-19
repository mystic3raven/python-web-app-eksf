resource "aws_ecr_repository" "python_web_app" {
  name = "python-web-app"

  image_scanning_configuration {
    scan_on_push = true
  }
  lifecycle {
    prevent_destroy = true
  }
}
