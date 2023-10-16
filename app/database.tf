#resource "aws_db_instance" "db_instance" {
#  allocated_storage   = 20
#  storage_type        = "standard"
#  engine              = "postgres"
#  engine_version      = "15.3"
#  instance_class      = "db.t3.micro"
#  username            = "myUser"
#  password            = "myPassw0rd"
#  skip_final_snapshot = true
#  identifier_prefix = "app-db-${var.environment_name}-"
#  publicly_accessible = true
#}
