
#Identificación del clúster al instalar el AWS Load Balancer Controller
output "cluster_name" {
  description = "Nombre del cluster EKS"
  value       = aws_eks_cluster.this.name
}

#proporcionar la conexión a la API de K8s
output "cluster_endpoint" {
  description = "Endpoint de la API de Kubernetes"
  value       = aws_eks_cluster.this.endpoint
}

#Verificar la identidad del servidor de la API mediante TLS
output "cluster_ca_certificate" {
  description = "Certificado CA del cluster EKS"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}
