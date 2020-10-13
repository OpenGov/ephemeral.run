# Terraform for creating the demo cluster for ephemeral.run

This is based on [Provision an EKS Cluster learn guide](https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster), containing Terraform configuration files to provision an EKS cluster on AWS for sample implementation of Ephemeral.run. The files have been modified as needed for the Ephemeral.run setup.

## Summary of resources created

Applying the terraform files here, will create the following resources:

1. EKS Cluster with 1 on-demand instance
2. Worker_groups for on-demand instance and spot instances
3. AWS IAM user for accessing the cluster from Github Actions
4. Required IAM Roles for service accounts to run cluster-autoscaler and external-dns

Note down the `ephemeral-gha-user` credentials, these will be required to update in github secrets for running the github actions.

## Prerequisites

1. An AWS Account with necessary iam permissions to create a cluster
2. A Hosted zone created with Route 53

## Steps to install the cluster

After installing the AWS CLI. Configure it to use your credentials.

```shell
$ aws configure
AWS Access Key ID [None]: <YOUR_AWS_ACCESS_KEY_ID>
AWS Secret Access Key [None]: <YOUR_AWS_SECRET_ACCESS_KEY>
Default region name [None]: <YOUR_AWS_REGION>
Default output format [None]: json
```

This enables Terraform access to the configuration file and performs operations on your behalf with these security credentials.

After you've done this, initalize your Terraform workspace, which will download
the provider and initialize it.

```shell
$ terraform init
Initializing modules...
Downloading terraform-aws-modules/eks/aws 9.0.0 for eks...
- eks in .terraform/modules/eks/terraform-aws-modules-terraform-aws-eks-908c656
- eks.node_groups in .terraform/modules/eks/terraform-aws-modules-terraform-aws-eks-908c656/modules/node_groups
Downloading terraform-aws-modules/vpc/aws 2.6.0 for vpc...
- vpc in .terraform/modules/vpc/terraform-aws-modules-terraform-aws-vpc-4b28d3d

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "template" (hashicorp/template) 2.1.2...
- Downloading plugin for provider "kubernetes" (hashicorp/kubernetes) 1.10.0...
- Downloading plugin for provider "aws" (hashicorp/aws) 2.52.0...
- Downloading plugin for provider "random" (hashicorp/random) 2.2.1...
- Downloading plugin for provider "local" (hashicorp/local) 1.4.0...
- Downloading plugin for provider "null" (hashicorp/null) 2.1.2...

Terraform has been successfully initialized!
```

Then, provision your EKS cluster by running `terraform apply`. This will
take approximately 15 minutes. Provide the values for variables as prompted.

```shell
$ terraform apply

# Output truncated...

Plan: 58 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

# Output truncated...

Apply complete! Resources: 58 added, 0 changed, 0 destroyed.

Outputs:

cluster_endpoint = https://17DE2B3DBAA8A9CA731C97685E5B4AF4.yl4.ap-south-1.eks.amazonaws.com
cluster_id = ephemeral-demo-spot
cluster_name = ephemeral-demo-spot
region = ap-south-1
ephemeral-gha-user_iam_creds_id = AKIAUUPCUWEZ3WMRURPY
ephemeral-gha-user_iam_creds_secret = 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
ephemeral-gha-user_iam_arn = arn:aws:iam::465833462251:user/ephemeral-gha-user

```

## Configure kubectl

To configure kubetcl, you need both [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) and [AWS IAM Authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html).

The following command will get the access credentials for your cluster and automatically
configure `kubectl`.

```shell
$ aws eks --region ap-south-1 update-kubeconfig --name ephemeral-demo-spot
```

The [Kubernetes cluster name](https://github.com/OpenGov/ephemeral.run/blob/main/platform-setup/terraform/outputs.tf#L6)
and [region](https://github.com/OpenGov/ephemeral.run/blob/main/platform-setup/terraform/outputs.tf#L1)
correspond to the output variables showed after the successful Terraform run.

You can view these outputs again by running:

```shell
$ terraform output
```
