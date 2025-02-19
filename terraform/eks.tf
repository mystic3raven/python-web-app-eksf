
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}



module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  fargate_profiles = {
    python-web-app = {
      selectors = [
        {
          namespace = "python-web-app"
        }
      ]
    }
  }
}

