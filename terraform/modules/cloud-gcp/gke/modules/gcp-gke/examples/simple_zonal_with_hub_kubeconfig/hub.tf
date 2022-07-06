

module "hub" {
  source                  = "../../modules/hub-legacy"
  project_id              = var.project_id
  location                = "remote"
  cluster_name            = kind_cluster.test-cluster.name
  cluster_endpoint        = kind_cluster.test-cluster.endpoint
  gke_hub_membership_name = kind_cluster.test-cluster.name
  gke_hub_sa_name         = "sa-for-kind-cluster-membership"
  use_kubeconfig          = true
  labels                  = "testlabel=usekubecontext"
}
