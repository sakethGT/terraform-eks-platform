#!/bin/bash
set -x

helm repo add stable https://charts.helm.sh/stable
helm repo update

helm install mgmt-npe-kube2iam stable/kube2iam --namespace kube-system -f mgmt-npe-kube2iam.yaml
helm install mgmt-npe-external-dns stable/external-dns --namespace kube-system -f mgmt-npe-external-dns.yaml
helm install mgmt-npe-nginx-ingress stable/nginx-ingress --namespace kube-system -f mgmt-npe-nginx-ingress.yaml --version v1.1.5
