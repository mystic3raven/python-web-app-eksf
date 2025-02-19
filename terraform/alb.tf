module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id  #  This should now be available
  public_subnet_ids = module.vpc.public_subnet_ids
}
