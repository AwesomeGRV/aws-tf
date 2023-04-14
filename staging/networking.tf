module "vpc" {
  source = "../modules/vpc"

  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  additional_tags = {
    resource    = "${var.environment}-vpc-networking"
    environment = "staging"
    owner       = "terraform"
  }
}





