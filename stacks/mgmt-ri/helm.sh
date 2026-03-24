#!/bin/bash
set -x

helm repo add stable https://charts.helm.sh/stable
helm repo update

helm install mgmt-ri-kube2iam stable/kube2iam --namespace kube-system -f mgmt-ri-kube2iam.yaml
helm install mgmt-ri-external-dns stable/external-dns --namespace kube-system -f mgmt-ri-external-dns.yaml
helm install mgmt-ri-nginx-ingress stable/nginx-ingress --namespace kube-system -f mgmt-ri-nginx-ingress.yaml --version v1.1.5
helm install cluster-autoscaler stable/cluster-autoscaler --namespace kube-system -f mgmt-ri-cluster-autoscaler.yaml
