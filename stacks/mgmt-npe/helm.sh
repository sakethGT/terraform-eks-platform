#!/bin/bash
set -x

kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller-cluster-role --clusterrole=cluster-admin  --serviceaccount=kube-system:tiller

helm init --upgrade --service-account tiller
helm repo add istio.io https://storage.googleapis.com/istio-prerelease/daily-build/master-latest-daily/charts

sleep 120

helm install stable/kube2iam --namespace kube-system --name mgmt-npe-kube2iam -f mgmt-npe-kube2iam.yaml
helm install stable/external-dns --namespace kube-system --name mgmt-npe-external-dns -f mgmt-npe-external-dns.yaml
helm install stable/nginx-ingress --namespace kube-system --name mgmt-npe-nginx-ingress -f mgmt-npe-nginx-ingress.yaml --version v1.1.5
