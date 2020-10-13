#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit

# Check for unused domain name for epehemeral environment
source get_domain.sh # import function

# Access yaml content
export $(yq r env.yaml -p pv '*.*' | sed -e 's/\./_/' -e 's/: /=/' -e 's/"//g')

# Run Skaffold
if [ "${1-default}" == "minikube" ]; then
  envsubst <skaffold.template.yaml >skaffold_"${minikube_dev_initials}"-"${minikube_work_item_id}".yaml
  skaffold dev --status-check=false --cache-artifacts=true -p minikube -f skaffold_"${minikube_dev_initials}"-"${minikube_work_item_id}".yaml 
  

elif [ "${1-default}" == "ephemeral-development" ]; then
  envsubst <skaffold.template.yaml >skaffold_"${ephemeral_dev_initials}"-"${ephemeral_work_item_id}".yaml
  get_domain # function call to get unused domain
  sed -i="" "s/DOMAIN_TO_USE/${DOMAIN_TO_USE}/g" skaffold_"${ephemeral_dev_initials}"-"${ephemeral_work_item_id}".yaml
  # ACM_CERT_ARN_ESC=$(sed 's/[\/]/\\&/g' <<<"${ephemeral_acm_cert_arn}")
  # sed -i "s/ACM_CERT_ARN/${ACM_CERT_ARN_ESC}/g" skaffold_"${ephemeral_dev_initials}"-"${ephemeral_work_item_id}".yaml
  wait
  NAMESPACE="${ephemeral_dev_initials}"-"${ephemeral_work_item_id}"
  # Create the namespace if it doesn't exist
  # (this works around a kube-janitor bug with helm 2: https://github.com/hjacobs/kube-janitor/issues/48)
  kubectl create namespace "${NAMESPACE}" || true
  # Exporting these values to enable skaffold to build zeus-service docker image
  export DOCKER_CLI_EXPERIMENTAL=enabled
  export DOCKER_BUILDKIT=1
  skaffold run -p ephemeral-development -f skaffold_"${ephemeral_dev_initials}"-"${ephemeral_work_item_id}".yaml
  # adding label namespace to enable management by kube-janitor
  kubectl label ns "${ephemeral_dev_initials}"-"${ephemeral_work_item_id}" ephemeralkubejanitor=true --overwrite
  echo "Domain assigned to the environment : ${DOMAIN_TO_USE}"

elif [ "${1-default}" == "ephemeral-development-delete" ]; then
  envsubst <skaffold.template.yaml >skaffold_"${ephemeral_dev_initials}"-"${ephemeral_work_item_id}".yaml
  skaffold delete -p ephemeral-development -f skaffold_"${ephemeral_dev_initials}"-"${ephemeral_work_item_id}".yaml
  kubectl delete namespaces "${ephemeral_dev_initials}"-"${ephemeral_work_item_id}" --ignore-not-found=true

### Below 2 option are mainly used in github actions workflow
elif [ "${1-default}" == "ephemeral-deploy" ]; then
  envsubst <skaffold.template.yaml >skaffold.yaml
  get_domain github_actions # function call to get unused domain for pr workflow
  sed -i="" "s/DOMAIN_TO_USE/$DOMAIN_TO_USE/g" skaffold.yaml
  #ACM_CERT_ARN_ESC=$(sed 's/[\/]/\\&/g' <<<"${ephemeral_acm_cert_arn}")
  #sed -i "s/ACM_CERT_ARN/${ACM_CERT_ARN_ESC}/g" skaffold.yaml
  wait
  NAMESPACE="${ephemeral_dev_initials}"-"${ephemeral_work_item_id}"
  # Create the namespace if it doesn't exist
  # (this works around a kube-janitor bug with helm 2: https://github.com/hjacobs/kube-janitor/issues/48)
  kubectl create namespace "${NAMESPACE}" || true
  skaffold deploy -p ephemeral-deployment -f skaffold.yaml --build-artifacts=default-tags.json
  # adding label namespace to enable management by kube-janitor
  kubectl label ns "${ephemeral_dev_initials}"-"${ephemeral_work_item_id}" ephemeralkubejanitor=true --overwrite
  echo "Domain assigned to the environment : ${DOMAIN_TO_USE}"
  # to be used in next github actions steps
  echo "${DOMAIN_TO_USE}" >/tmp/domain_name
  echo "${NAMESPACE}" >/tmp/namespace

elif [ "${1-default}" == "ephemeral-delete" ]; then
  envsubst <skaffold.template.yaml >skaffold.yaml
  skaffold delete -p ephemeral-deployment -f skaffold.yaml
  # Delete resource that are not deleted by skaffold, which otherwise cause delay in namespace deletion
  # kubectl delete svc delphiusapp-web-datasets delphiusapp-web zeus-service -n "${ephemeral_dev_initials}"-"${ephemeral_work_item_id}" --ignore-not-found=true
  # kubectl delete job delphiusapp-job-db-setup -n "${ephemeral_dev_initials}"-"${ephemeral_work_item_id}" --ignore-not-found=true
  kubectl delete namespaces "${ephemeral_dev_initials}"-"${ephemeral_work_item_id}" --ignore-not-found=true

else
  echo -e "usage: ./init.sh minikube or ./init.sh ephemeral-development or ./init.sh ephemeral-development-delete"
fi
