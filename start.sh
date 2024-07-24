#!/bin/bash
#[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
#chmod +x ./kind
./kind create cluster -n k8s --config kind-config.yaml

helm repo add apisix https://charts.apiseven.com
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
#  We use Apisix 3.0 in this example. If you're using Apisix v2.x, please set to v2
helm install apisix apisix/apisix \
  --set dashboard.enabled=true \
  --set ingress-controller.enabled=true \
  --create-namespace \
  --namespace ingress-apisix \
  --set ingress-controller.config.apisix.serviceNamespace=ingress-apisix \
  --set ingress-controller.config.apisix.adminAPIVersion=v3
kubectl get service --namespace ingress-apisix

# kubectl port-forward pods/apisix-ingress-controller-7fbf966b55-cj75l 8080:8080 -n ingress-apisix