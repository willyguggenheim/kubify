

output "kubernetes_endpoint" {
  value       = kind_cluster.test-cluster.endpoint
  description = "Kube API endpoint for the kind cluster"
}
