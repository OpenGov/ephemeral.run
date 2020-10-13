#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit
# This script is used to get the details of all the environments running in ephemeral cluster.
# It also enables user to delete the environments.

function list_namespaces() {
  IFS=$'\t'
  ns_defaults=("default\tkube-node-lease\tkube-public\tkube-system\tmanagement")
  unset IFS

  echo "------------------------------------------------------------------------------------------------------------------------------------"
  printf "%-20s|%-15s|%-5s|%-13s|%-15s|%-12s|%s\n" "Namespace" "Status" "Age" "DevInitials" "JIRA-ID/PR-Number" "Repository" "Domain"
  echo "------------------------------------------------------------------------------------------------------------------------------------"
  kubectl get ns |
    while read -r line; do
      if [[ $line != *"NAME"* ]]; then
        read -r namespace stats age <<<"$(echo "$line" | awk '{print $1, $2, $3}')"
        if [[ "\t${ns_defaults[@]}\t" =~ "\t${namespace}\t" ]]; then
          continue
        else
          domain=$(kubectl get svc -l app=nginx-ingress,component=controller -o yaml -n "$namespace" | grep 'external-dns.alpha.kubernetes.io/hostname' | awk '{print $2}' || echo "")
          if [[ $namespace =~ .*"zeus".* ]] || [[ $namespace =~ .*"voltron".* ]] || [[ $namespace =~ .*"delphiusapp".* ]]; then
            echo "$namespace" | awk -v ns="$namespace" -v stat="$stats" -v ag="$age" -v dn="$domain" -F - '{printf "%-20s|%-15s|%-5s|%-13s|%-17s|%-12s|%s\n",ns,stat,ag,$1,$3,$2,dn}'
          else
            echo "$namespace" | awk -v ns="$namespace" -v stat="$stats" -v ag="$age" -v dn="$domain" -v em=" " -F \| '{sub(/-/,"|");$1=$1;printf "%-20s|%-15s|%-5s|%-13s|%-17s|%-12s|%s\n",ns,stat,ag,$1,$2,em,dn }'
          fi
        fi
      fi
    done
  echo "------------------------------------------------------------------------------------------------------------------------------------"
}
function delete_namespace() {
  read -r -p "Do you want to delete any namespace (y/n)?" input
  case $input in
  [yY][eE][sS] | [yY])
    echo "Yes"
    read -r -p "Enter the namespace you want to delete: " namespace
    result=$(kubectl get po -n "$namespace")
    if [[ "$result" =~ "NAME" ]]; then
      read -r -p "This action cannot be undone! Are you sure you want to delete $namespace? (Yes/NO)" confirm
      case $confirm in
      [yY][eE][sS] | [yY])
        output=$(helm ls | grep "$namespace" | sed 's/\|/ /' | awk 'BEGIN { ORS=" " }; {print $1}' || echo "")
        for x in $output; do
          helm delete "$x" --purge
        done
        kubectl delete svc delphiusapp-web-datasets delphiusapp-web zeus-service -n "$namespace" --ignore-not-found=true
        kubectl delete job delphiusapp-job-db-setup -n "$namespace" --ignore-not-found=true
        if kubectl delete namespaces "$namespace" --ignore-not-found=true; then
          echo "namespace and resources deleted successfully"
        fi
        ;;
      [nN][oO] | [nN])
        exit 0
        ;;
      esac
    else
      RESOURCES=$(kubectl get all -n "$namespace" | grep -v -e '^$\|NAME' | awk '{print $1}' | tr '\r\n' ' ' || echo "service/zeus-service")
      kubectl delete "${RESOURCES}" --grace-period=100 -n "$namespace" --ignore-not-found=true
      if kubectl delete namespaces "$namespace" --ignore-not-found=true; then
        echo "No pods in the namespace and Namespace deleted successfully"
        exit 0
      fi
    fi
    ;;
  [nN][oO] | [nN])
    echo "No"
    ;;
  *)
    echo "Invalid input..."
    exit 1
    ;;
  esac
}
if [[ "${1-default}" == "help" ]]; then
  echo -e "usage: ./manage_env.sh \nLists the ephemral environments running currently\n\nAND\n\n ./manage_env.sh delete-namespace\nLists the ephemeral environments running and gives option to delete environment"
elif [[ "${1-default}" == "delete-namespace" ]]; then
  list_namespaces
  delete_namespace "${1-default}"
else
  list_namespaces
fi
