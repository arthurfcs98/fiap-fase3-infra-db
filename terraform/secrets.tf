# Senhas geradas randomicamente
resource "random_password" "db" {
  length  = 24
  special = false # evita "@:/" que confundem URIs Postgres
}

resource "random_password" "jwt" {
  length           = 48
  special          = true
  override_special = "!@#$%^&*()_+-=" # exclui chars que quebram JSON/YAML
}

# DB credentials JSON {host, port, username, password, dbname}
resource "aws_secretsmanager_secret" "db" {
  name                    = var.db_secret_name
  recovery_window_in_days = 0 # delete imediato no destroy (modo blitz)
  description             = "Credenciais de conexao do RDS Postgres (Fase 3)"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    host     = aws_db_instance.main.address
    port     = aws_db_instance.main.port
    username = aws_db_instance.main.username
    password = random_password.db.result
    dbname   = aws_db_instance.main.db_name
  })
}

# JWT signing secret (compartilhado entre Lambda Auth, Lambda Authorizer e API NestJS)
resource "aws_secretsmanager_secret" "jwt" {
  name                    = var.jwt_secret_name
  recovery_window_in_days = 0
  description             = "JWT signing secret (HS256) compartilhado entre Lambda Auth e API"
}

resource "aws_secretsmanager_secret_version" "jwt" {
  secret_id     = aws_secretsmanager_secret.jwt.id
  secret_string = random_password.jwt.result
}
