packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "kutt" {
  ami_name      = "kutt-server-aws-${local.timestamp}"
  source_ami    = "ami-04e601abe3e1a910f"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  ssh_username  = "ubuntu"
}

build {
  # install inst.
  sources = [
    "source.amazon-ebs.kutt"
  ]

  provisioner "file" {
    source      = "healthcheck.sh"
    destination = "/tmp/health_check.sh"
  }

  provisioner "shell" {
    script = "./run.sh"
  }

}