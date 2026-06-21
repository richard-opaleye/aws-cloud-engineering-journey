terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "nuvra-terraform-state-131404648372"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "dev_vpc" {
  source = "./modules/vpc"

  environment_name = "dev"
  vpc_cidr         = "10.40.0.0/16"
}

output "dev_vpc_id" {
  value = module.dev_vpc.vpc_id
}

output "dev_subnet_id" {
  value = module.dev_vpc.subnet_id
}
