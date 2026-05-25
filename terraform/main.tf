data "aws_caller_identity" "current" {}

# Outputs do repo fiap-fase3-infra-k8s (VPC + subnets)
data "terraform_remote_state" "k8s" {
  backend = "s3"
  config = {
    bucket = var.tfstate_bucket
    key    = "infra-k8s/terraform.tfstate"
    region = "us-east-1"
  }
}

# Subnet group reaproveitando as subnets publicas do EKS
# (nao e best practice pra RDS prod, mas evita NAT no sandbox blitz)
resource "aws_db_subnet_group" "main" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = data.terraform_remote_state.k8s.outputs.subnet_ids

  tags = { Name = "${var.db_identifier}-subnet-group" }
}

# Security group permite Postgres da VPC inteira (EKS pods + Lambda)
resource "aws_security_group" "db" {
  name        = "${var.db_identifier}-sg"
  description = "Allow Postgres from the VPC (EKS pods + Lambda)"
  vpc_id      = data.terraform_remote_state.k8s.outputs.vpc_id

  ingress {
    description = "Postgres 5432 from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.k8s.outputs.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.db_identifier}-sg" }
}

resource "aws_db_instance" "main" {
  identifier             = var.db_identifier
  engine                 = "postgres"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  storage_type           = "gp2"
  storage_encrypted      = true
  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.db.result
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false
  multi_az               = false

  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0
  apply_immediately       = true

  monitoring_interval          = 0
  performance_insights_enabled = false

  tags = { Name = var.db_identifier }
}
