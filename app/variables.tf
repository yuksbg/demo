# General Variables

variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "eu-central-1"
}

variable "app_name" {
  description = "Name of the web application"
  type        = string
  default     = "web-app"
}
variable "app_version" {
  description = "App version (docker tag)"
  type        = string
  default     = "latest"
}

variable "environment_name" {
  description = "Deployment environment (dev/staging/production)"
  type        = string
  default     = "production"
}

variable "ami" {
  description = "Amazon machine image to use for ec2 instance"
  type        = string
  default     = "ami-0ff38ada651020fc9" #build by packer
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t3.micro"
}


variable "create_dns_zone" {
  description = "If true, create new route53 zone, if false read existing route53 zone"
  type        = bool
  default     = false
}

variable "domain" {
  description = "Domain for website"
  type        = string
  default     = "demo01.yuks.me"
}


# EC2 Variables
data "aws_ami" "my_ami" {
  owners = ["self"]
  filter {
    name   = "name"
    values = ["kutt-server-aws-*"]
  }
  most_recent = true
}