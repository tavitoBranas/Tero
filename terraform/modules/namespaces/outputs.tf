output "namespace_names" {
  description = "Nombres de los namespaces creados"
  value = [
    for ns in kubernetes_namespace_v1.tero :
    ns.metadata[0].name
  ]
}