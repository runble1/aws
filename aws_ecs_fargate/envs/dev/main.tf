locals {
  product        = "nextjs-ecs"
  image_registry = "${data.aws_caller_identity.self.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com"
  app_image      = "${var.env}-ecs-nextjs-app:0.0.1"
}

module "s3" {
  source  = "../../modules/s3"
  product = "${var.env}-${local.product}"
}

module "network" {
  source            = "../../modules/network"
  env               = var.env
  service           = "${var.env}-${local.product}"
  s3_vpc_bucket_arn = module.s3.s3_vpc_bucket_arn
}

module "alb" {
  source              = "../../modules/alb"
  service             = "${var.env}-${local.product}"
  vpc_id              = module.network.vpc_id
  subnet_public_1a_id = module.network.subnet_public_1a_id
  subnet_public_1c_id = module.network.subnet_public_1c_id
  lb_port             = 80
  app_port            = 3000
  s3_alb_bucket_name  = module.s3.s3_alb_bucket_name
}

module "kms" {
  source  = "../../modules/kms"
  service = "${var.env}-${local.product}"
}

module "log" {
  source  = "../../modules/log"
  service = "${var.env}-${local.product}"
  key_arn = module.kms.key_arn
}

module "ecs" {
  source  = "../../modules/ecs"
  product = "${var.env}-${local.product}"
  key_arn = module.kms.key_arn
}

module "ecspresso" {
  depends_on                  = [module.ecs]
  source                      = "../../modules/ecspresso"
  product                     = "${var.env}-${local.product}"
  vpc_id                      = module.network.vpc_id
  subnet_1a_id                = module.network.subnet_private_1a_id
  subnet_1c_id                = module.network.subnet_private_1c_id
  alb_target_group_arn        = module.alb.target_group_arn
  alb_sg_id                   = module.alb.alb_sg_id
  ecs_sg_id                   = module.alb.ecs_sg_id
  app_port                    = 3000
  ecs_cluster_name            = module.ecs.ecs_cluster_name
  ecs_task_execution_role_arn = module.ecs.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.ecs.ecs_task_role_arn
  ecs_image_url               = "${local.image_registry}/${local.app_image}"
  ecs_log_group_name          = module.log.ecs_log_group_name
}
