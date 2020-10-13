# Getting Started with epehemeral.run

This repo has a sample implementation for ephemeral environments using the demo microservices application sock-shop.

For the sample implementation, the `front-end` repo has been forked at https://github.com/OpenGov/front-end

The main implementation and configuration is maintained in this repo (Ephemeral.run).

The sample minimum setup for the EKS Cluster is in [ephemeral.run/platform-setup](https://github.com/OpenGov/ephemeral.run/blob/main/platform-setup)

The configuration for the ephemeral environments is described in [ephemeral.run/ephemeral-env](https://github.com/OpenGov/ephemeral.run/blob/main/ephemeral-env)

## Run the sample

Follow the steps below to run the sample :

1. Fork the [front-end](https://github.com/microservices-demo/front-end) repo
2. Fork the [ephemeral.run](https://github.com/OpenGov/ephemeral.run) repo
3. Create and configure the EKS Cluster on your AWS Account. Refer [ephemeral.run/platform-setup](https://github.com/OpenGov/ephemeral.run/platform-setup/README.md)
4. Set the following secrets on your fork
   - DOCKERHUB_REPOSITORY
   - DOCKERHUB_USERNAME
   - DOCKERHUB_PASSWORD
   - GIT_HUB_ACCESS_TOKEN
   - AWS_CLUSTER_NAME
   - IAM_CLUSTER_USER
   - IAM_CLUSTER_PASSWORD
5. Make some change to the `front-end` codebase in a branch
6. Create a PR to your fork main.
7. A build will be triggered through github action. The build will push the image to your dockerhub repository.
8. Once build is completed, add a label `ephemeral-deploy` to the PR.
