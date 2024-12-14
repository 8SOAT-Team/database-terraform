resource "aws_db_instance" "sql_server" {
  allocated_storage = 20             # Tamanho do disco (em GB)
  storage_type      = "gp2"          # Tipo de armazenamento
  engine            = "sqlserver-ex" # Edição do SQL Server
  engine_version    = "15.00"        # Versão do SQL Server
  instance_class    = "db.t3.large" # Tipo de instância
  #name                    = var.databaseName          # Nome do banco de dados
  username            = var.user     # Nome do usuário master
  password            = var.password # Senha do usuário master
  publicly_accessible = true         # Acesso público ativado
  port                = 1433         # Porta padrão do SQL Server
  license_model = "license-included"

  vpc_security_group_ids = [aws_security_group.sql_server_sg.id] # Associando grupo de segurança
  skip_final_snapshot    = true                                  # Não cria snapshot ao destruir

  # Substituir pelo seu subnet group se necessário
  db_subnet_group_name = aws_db_subnet_group.sql_subnet_group.name
}

resource "aws_security_group" "sql_server_sg" {
  name        = "sql-server-sg"
  description = "Grupo de seguranca para o RDS SQL Server"

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir conexões de qualquer lugar (apenas para testes)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Permitir saída para qualquer destino
  }
}

resource "aws_db_subnet_group" "sql_subnet_group" {
  name        = "sql-subnet-group"
  description = "Subnet group para o RDS SQL Server"

  subnet_ids = [for subnet in data.aws_subnet.subnet : subnet.id if subnet.availability_zone != "${var.region}e"]
}

resource "aws_iam_role_policy_attachment" "rds_directory_services" {
  role       = data.aws_iam_role.labrole.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSDirectoryServiceAccess"
}

output "rds_endpoint" {
  value = aws_db_instance.sql_server.endpoint
}

output "rds_port" {
  value = aws_db_instance.sql_server.port
}
