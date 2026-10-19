# ==============================================================================
# variables.tf — Variables configurables del proyecto
# ==============================================================================

variable "aws_region" {
  description = "Región de AWS donde se crearán los recursos"
  type        = string
  default     = "us-east-2"
}

variable "instance_type" {
  description = "Tipo de instancia EC2 (t3.micro es Free Tier eligible)"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "ID de la AMI de Amazon Linux 2023 en us-east-2"
  type        = string
  default     = "ami-065cd998ed8162897"
}

variable "key_name" {
  description = "Nombre del par de claves SSH existente en AWS"
  type        = string
  default     = "lab3-key"
}

variable "my_ip" {
  description = "Tu dirección IP pública en formato CIDR (ej. 189.28.71.162/32)"
  type        = string
  # ⚠️ REEMPLAZA ESTO CON TU IP PÚBLICA ACTUAL
  default     = "189.28.71.162/32"
}