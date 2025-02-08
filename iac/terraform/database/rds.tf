resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_db_instance" "techchallenge_rds" {
  identifier               = "rds-fastorderdb-tf"
  allocated_storage        = 20
  engine                   = "sqlserver-ex"
  engine_version           = "15.00"
  instance_class           = "db.t3.micro"
  publicly_accessible      = true
  port                     = 1433
  delete_automated_backups = true
  skip_final_snapshot      = true
  username                 = var.user
  password                 = var.password
  vpc_security_group_ids   = [data.terraform_remote_state.network.outputs.aws_security_group_id]
  db_subnet_group_name     = aws_db_subnet_group.rds_subnet_group.name
  apply_immediately        = true
  license_model = "license-included"

  tags = {
    Name = "fastorderdb-RDS"
  }
}