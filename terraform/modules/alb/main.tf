resource "aws_lb" "eks_alb" {
  name               = "eks-fargate-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids # Ensure it uses the correct variable

  tags = {
    Name = "eks-fargate-alb"
  }
}

