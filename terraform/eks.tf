
module "iam" {
  source = "./modules/iam"
  cluster_name = var.cluster_name
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = "python-web-app-eksf"
  subnet_ids   = module.vpc.private_subnet_ids
}
