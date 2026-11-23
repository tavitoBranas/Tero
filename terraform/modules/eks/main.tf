
#se define el cluster de trabajao

# crea el clúster administrado por AWS
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = {
    Name = var.cluster_name
  }
}

# se definen las configuraciones de las instancias EC2 que utilizará el Node Group
resource "aws_launch_template" "nodes" {
  name_prefix = "${var.node_group_name}-"

  metadata_options {
    http_endpoint = "enabled" #habilita el servicio de metadatos
    http_tokens   = "required"
    #Exige IMDSv2 para consultar datos sobre las instancias y obtener credenciales temporales
    http_put_response_hop_limit = 2
    #Permite que las respuestas de IMDS atraviesen hasta dos saltos de red
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.node_group_name
    }
  }
}

# Managed Node Group: proporciona capacidad de cómputo
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name #indica wue debe crear el cluster antes que el node group
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn

  subnet_ids = var.subnet_ids #subnets donde se ejecutan los nodos

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  instance_types = var.instance_types
  ami_type       = "AL2023_x86_64_STANDARD"

  launch_template {
    id      = aws_launch_template.nodes.id
    version = aws_launch_template.nodes.latest_version
  }

  tags = {
    Name = var.node_group_name
  }
}
