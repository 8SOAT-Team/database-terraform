provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "sql_server" {
  allocated_storage       = 20                      # Tamanho do disco (em GB)
  storage_type            = "gp2"                 # Tipo de armazenamento
  engine                  = "sqlserver-se"        # Edição do SQL Server
  engine_version          = "15.00"              # Versão do SQL Server
  instance_class          = "db.t3.medium"       # Tipo de instância
  name                    = "fastorderdb"        # Nome do banco de dados
  username                = "sa"                # Nome do usuário master
  password                = "tech#2024"         # Senha do usuário master
  publicly_accessible     = true                  # Acesso público ativado
  port                    = 1433                 # Porta padrão do SQL Server

  vpc_security_group_ids  = [aws_security_group.sql_server_sg.id]  # Associando grupo de segurança
  skip_final_snapshot     = true                 # Não cria snapshot ao destruir

  # Substituir pelo seu subnet group se necessário
  db_subnet_group_name = aws_db_subnet_group.sql_subnet_group.name
}

resource "aws_security_group" "sql_server_sg" {
  name        = "sql-server-sg"
  description = "Grupo de segurança para o RDS SQL Server"

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir conexões de qualquer lugar (apenas para testes)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir saída para qualquer destino
  }
}

resource "aws_db_subnet_group" "sql_subnet_group" {
  name       = "sql-subnet-group"
  description = "Subnet group para o RDS SQL Server"

  subnet_ids = [
    "subnet-0e2429976cece5c29",  # Substitua pelos seus IDs de sub-rede
    "subnet-0b118303a38a224e13"
  ]
}

output "rds_endpoint" {
  value = aws_db_instance.sql_server.endpoint
}

output "rds_port" {
  value = aws_db_instance.sql_server.port
}
