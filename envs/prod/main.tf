terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket         = "deployments-tfstate-prod"
    key            = "state/prod-terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "deployments_tf_prod_lockid"
  }
}

provider "aws" {
  region = var.region
}

variable "domain" {
  description = "Domain for website"
  type        = string
  default     = "demo01.yuks.me"
}

variable "app_version" {
  description = "Deployed app tag"
  type        = string
  default     = "latest"
}

variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "eu-central-1"
}

module "production_app" {
  source           = "../../app"
  environment_name = "production"
  create_dns_zone  = false
  app_version      = var.app_version
  region           = var.region
  domain           = var.domain
}