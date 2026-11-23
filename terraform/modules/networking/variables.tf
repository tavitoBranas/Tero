#variables para la implementación del networking

#AZ hardcodeada ya que va a ser la única opción que se va a trabajar em este obligatorio

variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "Rango de direcciones IP de la VPC"
  type        = string
}

variable "public_subnets" {
  description = "Rangos CIDR de las subredes públicas"
  type        = list(string)
}

variable "cluster_name" {
  description = "Nombre del cluster EKS"
  type        = string
}
