resource "kubernetes_namespace_v1" "tero" {
  for_each = toset(var.namespaces)

  metadata {
    name = each.value

    labels = {
      project     = "tero"
      environment = each.value
    }
  }
}