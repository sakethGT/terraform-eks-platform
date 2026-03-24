#!/bin/bash
set -x

helm repo add stable https://charts.helm.sh/stable
helm repo update

helm install dev-npe-kube2iam stable/kube2iam --namespace kube-system -f dev-npe-kube2iam.yaml
helm install dev-npe-external-dns stable/external-dns --namespace kube-system -f dev-npe-external-dns.yaml
helm install dev-npe-nginx-ingress stable/nginx-ingress --namespace kube-system -f dev-npe-nginx-ingress.yaml --version v1.1.5
