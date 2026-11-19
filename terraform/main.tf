terraform {
  required_version = "= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.0.0"
    }
  }

  backend "s3" {
    bucket       = "tero-tf.state"
    key          = "tero/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true #habilita el bloqueo del state para evitar que dos ejecuciones de Terraform intenten modificarlo a la vez
  }
}

# Provider AWS
provider "aws" {
  region = "us-east-1"
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