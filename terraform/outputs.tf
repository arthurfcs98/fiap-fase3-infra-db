output "db_endpoint" {
  description = "Endpoint do RDS (host:port)"
  value       = aws_db_instance.main.endpoint
}

output "db_address" {
  description = "Hostname do RDS"
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "Porta do RDS"
  value       = aws_db_instance.main.port
}

output "db_name" {
  description = "Nome do banco"
  value       = aws_db_instance.main.db_name
}

output "db_secret_arn" {
  description = "ARN do secret de credenciais (consumido por Lambda e API)"
  value       = aws_secretsmanager_secret.db.arn
}

output "jwt_secret_arn" {
  description = "ARN do JWT signing secret (compartilhado entre Lambda Auth, Authorizer, API)"
  value       = aws_secretsmanager_secret.jwt.arn
}

output "db_security_group_id" {
  description = "Security group do RDS"
  value       = aws_security_group.db.id
}
