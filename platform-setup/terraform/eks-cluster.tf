locals {
  worker_subnets       = "${module.vpc.private_subnets[0]}"
  loadbalancer_subnets = "${module.vpc.public_subnets[0]}"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  subnets         = module.vpc.private_subnets
  cluster_version = "1.15"
  enable_irsa     = true

  tags = {
    Environment = "ephemeral-run-demo"
    GithubRepo  = "ephemeral.run"
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                 = "worker-green-on-demand"
      instance_type        = "t2.medium"
      asg_desired_capacity = "1"
      asg_max_size         = "2"
      asg_min_size         = "1"
      kubelet_extra_args   = "--register-with-taints=nodeLifeCycle=normal:NoSchedule --node-labels=kubernetes.io/lifecycle=normal,kubernetes.io/role=worker-green-on-demand"
      subnets              = ["${local.worker_subnets}"]
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
          "propagate_at_launch" = "false"
          "value"               = "true"
        }
      ]
    },
    {
      name                         = "worker-green-spot"
      instance_type                = "t2.medium"
      asg_desired_capacity         = "0"
      asg_max_size                 = "3"
      asg_min_size                 = "0"
      autoscaling_node_label_key   = "kubernetes.io/lifecycle"
      autoscaling_node_label_value = "spot"
      kubelet_extra_args           = "--node-labels=kubernetes.io/lifecycle=spot,kubernetes.io/role=worker-green-spot"
      subnets                      = ["${local.worker_subnets}"]
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
          "propagate_at_launch" = "false"
          "value"               = "true"
        }
      ]
    }
  ]
  map_users = var.map_users
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
