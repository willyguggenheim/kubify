

provider "kind" {}

# creating a cluster with kind of the name "test-cluster" with kubernetes version v1.18.4 and two nodes
resource "kind_cluster" "test-cluster" {
  name           = "test-cluster"
  node_image     = "kindest/node:v1.18.4"
  wait_for_ready = true
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
    }
    node {
      role = "worker"
    }
  }
  provisioner "local-exec" {
    command = "kubectl config set-context kind-test-cluster"
  }
}
