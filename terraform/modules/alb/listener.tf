resource "aws_lb_target_group" "eks_tg" {
  name        = "eks-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id # ✅ Use var.vpc_id instead of module.vpc.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
