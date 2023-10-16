locals {
  docker_image = "kutt/kutt:${var.app_version}"
  db_user = "myUser"
  db_pass = "MyPas@word"
  db_name = "kutt"
  ami = data.aws_ami.my_ami.id
  app_name = "Kutt - (${var.environment_name}) ${var.app_version} "
}

resource "aws_instance" "redis_instance" {
  ami             = local.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instances.name]
  user_data       = <<-EOF
              #!/bin/bash
              service docker start
              docker run -it -d -p "6379:6379" --restart=always redis
              EOF
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.app_name}-${var.environment_name}-redis"
    ENV = var.environment_name
  }
}

resource "aws_instance" "postgres_instance" {
  ami             = local.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instances.name]
  user_data       = <<-EOF
              #!/bin/bash
              service docker start
              docker run -it -d -p "5432:5432" -e POSTGRES_USER=${local.db_user} -e POSTGRES_PASSWORD=${local.db_pass} -e POSTGRES_DB=${local.db_name} --restart=always postgres:12-alpine
              EOF
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.app_name}-${var.environment_name}-postgres"
    ENV = var.environment_name
  }
}

resource "aws_instance" "instance_1" {
  ami             = local.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instances.name]
  user_data       = <<-EOF
              #!/bin/bash
              service docker start
              mkdir -p /opt/kutt && cd /opt/kutt
              wget https://raw.githubusercontent.com/thedevs-network/kutt/develop/.docker.env
              mv .docker.env .env
              sed -i~ '/^DEFAULT_DOMAIN=/s/=.*/=${aws_route53_record.root.name}/' .env
              sed -i~ '/^DB_HOST=/s/=.*/=${aws_instance.postgres_instance.private_ip}/' .env
              sed -i~ '/^DB_USER=/s/=.*/=${local.db_user}/' .env
              sed -i~ '/^DB_PASSWORD=/s/=.*/=${local.db_pass}/' .env
              sed -i~ '/^SITE_NAME=/s/=.*/=${local.app_name}/' .env
              sed -i~ '/^REDIS_HOST=/s/=.*/=${aws_instance.redis_instance.private_ip}/' .env
              sed -i~ '/^DISALLOW_REGISTRATION=/s/=.*/=true/' .env
              sed -i~ '/^CUSTOM_DOMAIN_USE_HTTPS=/s/=.*/=false/' .env
              docker run -d -p "8080:3000" --restart=unless-stopped --env-file=/opt/kutt/.env ${local.docker_image}
              EOF

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.app_name}-${var.environment_name}-ec2-1"
    ENV = var.environment_name
    DockerIMG = local.docker_image
  }
}

resource "aws_instance" "instance_2" {
  ami             = local.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instances.name]
  user_data       = <<-EOF
              #!/bin/bash
              service docker start
              mkdir -p /opt/kutt && cd /opt/kutt
              wget https://raw.githubusercontent.com/thedevs-network/kutt/develop/.docker.env
              mv .docker.env .env
              sed -i~ '/^DEFAULT_DOMAIN=/s/=.*/=${aws_route53_record.root.name}/' .env
              sed -i~ '/^DB_HOST=/s/=.*/=${aws_instance.postgres_instance.private_ip}/' .env
              sed -i~ '/^DB_USER=/s/=.*/=${local.db_user}/' .env
              sed -i~ '/^DB_PASSWORD=/s/=.*/=${local.db_pass}/' .env
              sed -i~ '/^SITE_NAME=/s/=.*/=${local.app_name}/' .env
              sed -i~ '/^REDIS_HOST=/s/=.*/=${aws_instance.redis_instance.private_ip}/' .env
              sed -i~ '/^DISALLOW_REGISTRATION=/s/=.*/=true/' .env
              sed -i~ '/^CUSTOM_DOMAIN_USE_HTTPS=/s/=.*/=false/' .env
              docker run -d -p "8080:3000" --restart=unless-stopped --env-file=/opt/kutt/.env ${local.docker_image}
              EOF

  lifecycle {
    create_before_destroy = true
  }


  tags = {
    Name = "${var.app_name}-${var.environment_name}-ec2-2"
    ENV = var.environment_name
    DockerIMG = local.docker_image
  }
}