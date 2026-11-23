terraform {
  required_version = "= 1.17.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.0.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "= 3.1.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.38.0"
    }

  }

  backend "s3" {
    bucket       = "tero-tf.state"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true #habilita el bloqueo del state para evitar que dos ejecuciones de Terraform intenten modificarlo a la vez
  }
}

# Provider AWS
provider "aws" {
  region = "us-east-1"
}

# Conexion de Helm con el cluster EKS
provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name,
        "--region",
        "us-east-1"
      ]
    }
  }
}

# Conexion del provider Kubernetes con EKS
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name,
      "--region",
      "us-east-1"
    ]
  }
}

# Repositorios ECR para los microservicios
resource "aws_ecr_repository" "tero" {
  for_each = toset([
    "admin",
    "cart",
    "catalog",
    "checkout",
    "orders",
    "ui"
  ])

  name = "tero-${each.key}"

  image_tag_mutability = "IMMUTABLE"
}

# URLs de los repositorios
output "ecr_repository_urls" {
  value = {
    for service, repo in aws_ecr_repository.tero :
    service => repo.repository_url
  }
}

#vinculo con el modulo de networking

module "networking" {
  source = "./modules/networking"

  vpc_name       = "tero-vpc"
  vpc_cidr_block = "10.0.0.0/16"

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  cluster_name = "tero-eks"
}


module "eks" {
  source = "./modules/eks"

  cluster_name       = "tero-eks"
  kubernetes_version = "1.35"

  cluster_role_arn = data.aws_iam_role.labrole.arn
  node_role_arn    = data.aws_iam_role.labrole.arn

  subnet_ids = module.networking.public_subnet_ids #se obtienen los ids de subnets y los proporciona aqui

  node_group_name = "tero-node-group"

  #se setean los valores de las instancias según ambientes
  instance_types    = var.node_instance_types
  node_desired_size = var.node_desired_size
  node_min_size     = var.node_min_size
  node_max_size     = var.node_max_size

}

data "aws_iam_role" "labrole" {
  name = "LabRole"
}

# Instalación del AWS Load Balancer Controller en EKS
module "alb_controller" {
  source       = "./modules/alb_controller"
  cluster_name = module.eks.cluster_name
  aws_region   = "us-east-1"
  vpc_id       = module.networking.vpc_id

  depends_on = [module.eks]
}

# Namespaces Kubernetes para los ambientes de Tero
module "namespaces" {
  source = "./modules/namespaces"

  namespaces = [
    "dev",
    "test",
    "prod"
  ]

  depends_on = [module.eks]
}
