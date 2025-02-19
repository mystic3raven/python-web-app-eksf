resource "aws_lb" "eks_alb" {
  name               = "eks-fargate-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnet_ids

  tags = {
    Name = "eks-fargate-alb"
  }
}
