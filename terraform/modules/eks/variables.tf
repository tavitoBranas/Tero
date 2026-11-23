# ──────────────────────────────────────────────────────────
# Variables para el cluster 
# OBJ: Configuración de EKS
# ──────────────────────────────────────────────────────────

variable "cluster_name" {
  description = "Nombre del cluster EKS"
  type        = string
}

variable "kubernetes_version" {
  description = "Version de Kubernetes"
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN del rol IAM del cluster EKS"
  type        = string
}

# ──────────────────────────────────────────────────────────
# Variables para networking y IAM
# OBJ: Conexión con la VPC y permisos de nodos
# ──────────────────────────────────────────────────────────

variable "node_role_arn" {
  description = "ARN del rol IAM de los nodos"
  type        = string
}

variable "subnet_ids" {
  description = "IDs de las subnets utilizadas por EKS"
  type        = list(string)
}

# ──────────────────────────────────────────────────────────
# Variables para los nodos 
# OBJ: Capacidad de ejecución
# ──────────────────────────────────────────────────────────

variable "node_group_name" {
  description = "Nombre del Node Group"
  type        = string
}

variable "instance_types" {
  description = "Tipos de instancias EC2 para los nodos"
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
