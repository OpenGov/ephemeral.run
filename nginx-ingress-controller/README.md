This is the custom values file that is used to provide values to `stable/nginx-ingres` helm chart.

We are using the docker image `nginx-ingress-controller:0.27.0` kept in our own repo, this is just copy of the original nginx image & does not contain any customization.

Custom values file contains below parameters:

- config.proxy-body-size : to set the value for max allowed size of file upload
- scope:enabled.namespace : to add namespace scope to the ingress controller
- imagePullSecrets : secret name to use to pull the image from docker registry (provided via skaffold paramters)

To see the full list of paramters for customization, please check below link:
`https://github.com/helm/charts/tree/master/stable/nginx-ingress`
