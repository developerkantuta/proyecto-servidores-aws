# ==============================================================================
# main.tf — Configuración de OpenTofu para los servidores Backend y Frontend
# ==============================================================================

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ==============================================================================
# VPC y Subred (usamos la VPC por defecto para simplificar el laboratorio)
# ==============================================================================
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ==============================================================================
# Security Group para el Frontend (permite HTTP/HTTPS y SSH)
# ==============================================================================
resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Permite HTTP/HTTPS desde Internet y SSH desde mi IP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP desde Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS desde Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH desde mi IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    description = "Permitir todo el trafico saliente"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-sg"
    Lab  = "servidores-web"
  }
}

# ==============================================================================
# Security Group para el Backend (permite tráfico desde el Frontend y SSH)
# ==============================================================================
resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Permite trafico desde el frontend y SSH desde mi IP"
  vpc_id      = data.aws_vpc.default.id

  # Permite que el frontend se conecte al backend (ej. puerto 3000 o 8080)
  ingress {
    description     = "API desde el Frontend"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  # Permite conexiones al backend desde el propio frontend si usan otro puerto (ej. 8080)
  ingress {
    description     = "API alternativa desde el Frontend"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  ingress {
    description = "SSH desde mi IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    description = "Permitir todo el trafico saliente"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-sg"
    Lab  = "servidores-web"
  }
}

# ==============================================================================
# Instancia EC2 para el Frontend
# ==============================================================================
resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  subnet_id              = data.aws_subnets.default.ids[0]

  tags = {
    Name = "servidor-frontend"
    Lab  = "servidores-web"
  }
}

# ==============================================================================
# Instancia EC2 para el Backend
# ==============================================================================
resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  subnet_id              = data.aws_subnets.default.ids[0]

  tags = {
    Name = "servidor-backend"
    Lab  = "servidores-web"
  }
}