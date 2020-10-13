# Patch CoreDNS deployment

The EKS cluster created for the sample configuration has on-demand nodes with taint `nodeLifeCycle=normal:NoSchedule`. 

The on-demans nodes are only used for management components like botkube, cluster-autoscaler, external-dns, kube-janitor. All these components have relevant tolerations defined allowing these to be created on the on-demand nodes.

However, the CoreDNS deployment created by the aws-eks module doesn't have the relevant tolerations and hence it remains pending.

To remediate the situation, we need to patch the coredns deployment with tolerations so that it can be run on the on-demand nodes.

Use the following command to patch the coredns deployment :

`kubectl patch deployment coredns -n kube-system --patch="$(cat coredns.yaml)"`