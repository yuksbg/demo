terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket         = "deployments-tfstate-uat"
    key            = "state/uat-terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "deployments_tf_uat_lockid"
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

module "uat_app" {
  source           = "../../app"
  environment_name = "uat"
  create_dns_zone  = false
  app_version      = var.app_version
  region           = var.region
  domain           = var.domain
}