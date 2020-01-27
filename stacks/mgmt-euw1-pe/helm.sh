#!/bin/bash
set -x

kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller-cluster-role --clusterrole=cluster-admin  --serviceaccount=kube-system:tiller

helm init --upgrade --service-account tiller
helm repo add istio.io https://storage.googleapis.com/istio-prerelease/daily-build/master-latest-daily/charts

sleep 120

helm install stable/kube2iam --namespace kube-system --name mgmt-euw1-pe-kube2iam -f mgmt-euw1-pe-kube2iam.yaml
helm install stable/external-dns --namespace kube-system --name mgmt-euw1-pe-external-dns -f mgmt-euw1-pe-external-dns.yaml
helm install stable/nginx-ingress --namespace kube-system --name mgmt-euw1-pe-nginx-ingress -f mgmt-euw1-pe-nginx-ingress.yaml --version v1.1.5
