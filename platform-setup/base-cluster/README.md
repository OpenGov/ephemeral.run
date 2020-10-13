# Base Cluster Helm Chart

Requires helm 3.

This helm chart installs the required management components for the Ephemeral.run environment.

1. `external-dns` - for DNS zone management
2. `cluster-autoscaler` - for autoscaling
3. `kube-janitor` - to ensure unused environments are deleted after set TTL
4. `botkube` - for chatops with kubernetes cluster

For each of the components, following values need to be set at a minimum.

## external-dns

Update the AWS Account id correctly for [Service Account Annotation](https://github.com/OpenGov/ephemeral.run/blob/main/platform-setup/base-cluster/values.yaml#L87)

## cluter-autoscaler

Update the AWS Account id correctly for [Service Account Annotation](https://github.com/OpenGov/ephemeral.run/blob/main/platform-setup/base-cluster/values.yaml#L183)

## botkube

1. Add Botkube to your slack workspace and note the token.
2. Update [SLACK_TOKEN](https://github.com/OpenGov/ephemeral.run/blob/main/platform-setup/base-cluster/values.yaml#L48)
3. Update [SLACK Channel] where you want the notifications(https://github.com/OpenGov/ephemeral.run/blob/main/platform-setup/base-cluster/values.yaml#L46)

## kube-janitor

1. Update the [TTL](https://github.com/OpenGov/ephemeral.run/blob/main/platform-setup/base-cluster/values.yaml#L147) to the appropriate value. TTL defines the time for which the environments lives. Once TTL expires, the environment will be deleted.
