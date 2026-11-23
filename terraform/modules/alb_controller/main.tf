
# AWS Load Balancer Controller: cada Ingress con ingressClassName "alb"
# genera un Application Load Balancer.
#
# AWS Academy: no se crean roles IAM ni OIDC provider. El controller toma las
# credenciales de LabRole (rol de los nodos) via IMDS.

resource "helm_release" "this" { # Recurso Terraform que instala y administra una aplicación mediante Helm.
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller" # Chart que instala el AWS Load Balancer Controller.
  version    = "1.13.0"
  namespace  = "kube-system" # Namespace donde se instala el controlador.

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = var.vpc_id
    },
    # WAF y Shield no estan disponibles en el lab.
    {
      name  = "enableShield" # Protege frente a ataques DDoS, intentan saturar un servicio con grandes cantidades de tráfico.
      value = "false"
    },
    {
      name  = "enableWaf" # firewall que permite filtrar solicitudes HTTP/HTTPS
      value = "false"
    },
    {
      name  = "enableWafv2" # versión más moderna de AWS WAF
      value = "false"
    }
  ]

}
