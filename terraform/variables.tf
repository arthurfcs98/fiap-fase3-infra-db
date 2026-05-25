variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "homolog"
}

variable "tfstate_bucket" {
  type    = string
  default = "fiap-fase3-tfstate-235841326345"
}

variable "db_identifier" {
  type    = string
  default = "fiap-fase3-db"
}

variable "db_name" {
  type    = string
  default = "oficina"
}

variable "db_username" {
  type    = string
  default = "fiapadmin"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_engine_version" {
  type    = string
  default = "16.3"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_secret_name" {
  type    = string
  default = "fiap-fase3-db-credentials"
}

variable "jwt_secret_name" {
  type    = string
  default = "fiap-fase3-jwt-secret"
}
