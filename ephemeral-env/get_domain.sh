#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit

function get_domain() {
  declare -a ALL_DOMAINS=()
  declare -a USED_DOMAINS=()
  declare -a UNUSED_DOMAINS=()

  declare label="nginx-ingress-controller-"${ephemeral_dev_initials}"-"${ephemeral_work_item_id}"-nginx-ingress"
  if kubectl get svc -l app.kubernetes.io/name=${label} -o yaml -n "${ephemeral_dev_initials}"-"${ephemeral_work_item_id}" >/dev/null 2>&1; then
    # We are able to connect to the cluster.
    CURRENT_DOMAIN=$(kubectl get svc -l app.kubernetes.io/name=${label} -o yaml -n "${ephemeral_dev_initials}"-"${ephemeral_work_item_id}" | grep 'external-dns.alpha.kubernetes.io/hostname' | awk '{print $2}' || echo "")
    if [ -n "$CURRENT_DOMAIN" ]; then
      # Domain is already assigned to the env, use that.
      echo "Domain currenlty in use : ${CURRENT_DOMAIN}"
      DOMAIN_TO_USE="${CURRENT_DOMAIN}"
    else
      # Domain currently not assigned to the env
      echo "No Domain in use for this environment; looking for unused domains..."

      # Read domain list from file domain_names.txt
      count=0
      while IFS= read -r line; do
        ALL_DOMAINS["$count"]="$line"
        count=$(($count + 1))
      done <domain_names.txt

      # Get the existing route53 records filtered by specified DOMAIN_FILTER
      if aws route53 list-resource-record-sets --hosted-zone-id "${ephemeral_hostedzone}" --query "ResourceRecordSets[?Type=='A'].[Name]" >/dev/null 2>&1; then
        # Able to connect to query route53
        ROUTE53_DOMAINS=$(aws route53 list-resource-record-sets --hosted-zone-id "${ephemeral_hostedzone}" --query "ResourceRecordSets[?Type=='A'].[Name]" | grep "${ephemeral_domain_filter}" | awk -F '"' '{print $2}' | sed 's/.$//' || echo "")
        count=0
        for i in ${ROUTE53_DOMAINS}; do
          count=$(($count + 1))
          USED_DOMAINS["$count"]="$i"
        done
      else
        # Not able to query route53
        echo "Failed to query route53, please check the credentials"
        exit 1
      fi

      # Compare all domain list with used domains & get the list of unused domains
      count=0
      for DOMAIN in "${ALL_DOMAINS[@]}"; do
        USED=false
        for USEDDOMAIN in "${USED_DOMAINS[@]}"; do
          if [ "$DOMAIN" == "$USEDDOMAIN" ]; then
            USED=true
            break
          fi
        done
        if [ "$USED" == false ]; then
          count=$(($count + 1))
          UNUSED_DOMAINS["$count"]="$DOMAIN"
        fi
      done

      # check if any unused domain is available & select a random one from unused domains.
      if [ "${#UNUSED_DOMAINS[@]}" -eq 0 ]; then
        printf "\nThere is no ephemeral environment capacity at this time.\nPlease remove an unused epehemeral environment to free up a domain name and try again.\n"
        exit 1
      else
        # Seed random generator
        RANDOM=$(date +%s)

        # Select random domain name from unused domain names to use
        DOMAIN_TO_USE="${UNUSED_DOMAINS[$((RANDOM % ${#UNUSED_DOMAINS[@]} + 1))]}"
        export DOMAIN_TO_USE
      fi
    fi
  else
    echo "Failed to connect to cluster, please check the credentials"
    exit 1
  fi
}
