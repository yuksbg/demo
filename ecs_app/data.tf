data "aws_vpc" "this" {
  default = true
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.this.id
}

data "aws_security_group" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}