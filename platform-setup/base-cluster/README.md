# Base Cluster Helm Chart

Requires helm 3.

This helm chart installs the required management components for the Ephemeral.run environment.

1. `external-dns` - for DNS zone management
2. `cluster-autoscaler` - for autoscaling
3. `kube-janitor` - to ensure unused environments are deleted after set TTL
4. `botkube` - for chatops with kubernetes cluster

For each of the components, following values need to be set at a minimum.

## Usage

### Setup

Install helm 3 or above.

### Configure

Update the following items in [values.yaml](platform-setup/base-cluster/values.yaml):

#### external-dns and cluster-autoscaler

Replace `<ACCOUNT_ID>` with your own AWS Account id:

```
account_id="$(aws sts get-caller-identity | jq -r .Account)"
sed -i -e "s/<ACCOUNT_ID>/${account_id}/" values.yaml
```

#### botkube

1. Add Botkube to your slack workspace and note the token.
2. Update [`<SLACK_TOKEN>`](platform-setup/base-cluster/values.yaml#L69)
3. Update [`<SLACK CHANNEL>`](platform-setup/base-cluster/values.yaml#L67) where you want the notifications

#### kube-janitor

1. Update the [`ttl`](platform-setup/base-cluster/values.yaml#L168) to the appropriate value. TTL defines the time for which the environments lives. Once TTL expires, the environment will be deleted.

### Apply

From the `platform-setup/base-cluster/` directory, run:

```
helm lint
helm dependency update
helm install NAME_OF_YOUR_CHOICE . --values values.yaml
```
