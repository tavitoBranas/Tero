
#se exponen los valores del modulo de networking una vez deplegados, para ser empleados en 
#otros módulos

output "vpc_id" {
  description = "Id de la vpc desplegada para Tero"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Ids de la subnets publicas"
  value       = aws_subnet.public[*].id
}
