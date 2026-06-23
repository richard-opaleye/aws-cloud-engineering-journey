terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

module "sqs" {
  source       = "./modules/sqs"
  project_name = var.project_name
}

module "ecs" {
  source            = "./modules/ecs"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.vpc.alb_sg_id
  ecs_sg_id         = module.vpc.ecs_sg_id
  sqs_queue_arn     = module.sqs.queue_arn
}

module "monitoring" {
  source           = "./modules/monitoring"
  project_name     = var.project_name
  sqs_queue_name   = "${var.project_name}-payments"
  alb_arn_suffix   = module.ecs.alb_dns_name
  alarm_email      = var.alarm_email
}
