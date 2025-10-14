
# rds instance
resource "aws_db_instance" "postgres" {
  identifier                = "${var.environment}-${var.app}-db"
  allocated_storage         = tonumber(var.rds_defaults["allocated_storage"])
  max_allocated_storage     = tonumber(var.rds_defaults["max_allocated_storage"])
  engine                    = var.rds_defaults["engine"]
  engine_version            = var.rds_defaults["engine_version"]
  instance_class            = var.rds_defaults["instance_class"]
  username                  = var.rds_defaults["username"]
  password                  = random_password.dbs_random_string.result
  port                      = 5432
  publicly_accessible       = false
  db_subnet_group_name      = aws_db_subnet_group.postgres.id
  ca_cert_identifier        = "rds-ca-rsa2048-g1"
  storage_encrypted         = true
  storage_type              = "gp3"
  kms_key_id                = data.aws_kms_key.rds_kms.arn
  skip_final_snapshot       = false
  final_snapshot_identifier = "mydb-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  vpc_security_group_ids    = [aws_security_group.rds.id]

  backup_retention_period    = 7
  auto_minor_version_upgrade = true
  deletion_protection        = false
  copy_tags_to_snapshot      = true
}


#rds subnet group --> put both rds subnets to it
resource "aws_db_subnet_group" "postgres" {
  name       = "${var.environment}-${var.app}-subnet-group"
  subnet_ids = [aws_subnet.rds-1.id, aws_subnet.rds-2.id] # created from network.tf and mapped in this line.
}

# rds security group (inbound port 5432 open to ecs security group only)
resource "aws_security_group" "rds" {
  name        = "${var.environment}-${var.app}-rds-sg"
  description = "Allow inbound PostgreSQL access from ECS only"
  vpc_id      = aws_vpc.main.id

  # inbound rule from ecs security group only 
  ingress {
    description     = "PostgreSQL from ECS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_service_sg.id] # dont forget to create ecs security group in ecs.tf
  }

  # allowed all outbound 
  egress {
    from_port   = 0 # 0 means all ports allowed
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.app}-db-rds-sg"
  }
}





## Password for master username and secret manager secret
# create a password for the rds instance --> random provider (go to versions.tf and add random provider)
resource "random_password" "dbs_random_string" {
  length           = 10
  special          = false #no special characters
  override_special = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

}



#store the password in secret manager
resource "aws_secretsmanager_secret" "db_link" {
  name                    = "db/${aws_db_instance.postgres.identifier}"
  description             = "DB_link"
  kms_key_id              = data.aws_kms_key.rds_kms.arn #copied from data.tf
  recovery_window_in_days = 7
  lifecycle {
    create_before_destroy = true
  }
}

# # we build the secret here
resource "aws_secretsmanager_secret_version" "db_link_version" {
  secret_id = aws_secretsmanager_secret.db_link.id
  secret_string = jsonencode({
    #db_link = "postgresql://{username}:{password}@{address}:{port}/{dbname}"
    # from aws_db_instance resource above .last part (username, password, address, port, dbname) is from the document attributes
    db_link = "postgresql://${aws_db_instance.postgres.username}:${random_password.dbs_random_string.result}@${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}/${aws_db_instance.postgres.db_name}"

  })

  depends_on = [aws_db_instance.postgres]
}