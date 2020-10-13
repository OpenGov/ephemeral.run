locals {
  cluster_name                 = "ephemeral-demo-spot"
  CA_service_account_namespace = "management"
  CA_service_account_name      = "base-cluster-aws-cluster-autoscaler"
  ED_service_account_namespace = "management"
  ED_service_account_name      = "base-cluster-external-dns"
}
