# ==============================================================================
# outputs.tf — Salidas del proyecto (IPs públicas)
# ==============================================================================

output "frontend_public_ip" {
  description = "IP pública del servidor Frontend"
  value       = aws_instance.frontend.public_ip
}

output "backend_public_ip" {
  description = "IP pública del servidor Backend"
  value       = aws_instance.backend.public_ip
}

output "frontend_private_ip" {
  description = "IP privada del servidor Frontend"
  value       = aws_instance.frontend.private_ip
}

output "backend_private_ip" {
  description = "IP privada del servidor Backend"
  value       = aws_instance.backend.private_ip
}