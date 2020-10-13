#!/usr/bin/env bash
set -o pipefail
set -o nounset
set -o errexit

helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update

echo "=== Helm dependencies updated! ==="
