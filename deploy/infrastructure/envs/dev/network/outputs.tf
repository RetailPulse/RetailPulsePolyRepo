output "vpc_id"              { value = module.vpc.vpc_id }
output "public_subnets"      { value = module.vpc.public_subnets }
output "private_app_subnets" { value = module.vpc.private_subnets }
output "database_subnets"    { value = module.vpc.database_subnets }
output "alb_sg_id"           { value = aws_security_group.alb.id }