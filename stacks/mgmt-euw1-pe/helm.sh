#!/bin/bash
set -x

helm repo add stable https://charts.helm.sh/stable
helm repo update

helm install mgmt-euw1-pe-kube2iam stable/kube2iam --namespace kube-system -f mgmt-euw1-pe-kube2iam.yaml
helm install mgmt-euw1-pe-external-dns stable/external-dns --namespace kube-system -f mgmt-euw1-pe-external-dns.yaml
helm install mgmt-euw1-pe-nginx-ingress stable/nginx-ingress --namespace kube-system -f mgmt-euw1-pe-nginx-ingress.yaml --version v1.1.5
