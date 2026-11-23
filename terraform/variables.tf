
variable "node_instance_types" {
  description = "Tipos de instancias EC2 para EKS"
  type        = list(string)
}

variable "node_desired_size" {
  description = "Cantidad deseada de nodos"
  type        = number
}

variable "node_min_size" {
  description = "Cantidad minima de nodos"
  type        = number
}

variable "node_max_size" {
  description = "Cantidad maxima de nodos"
  type        = number
}
