#!/usr/bin/env bash

k create ns tiller
k apply -f ./helm-rbac.yaml
helm init --tiller-namespace tiller --service-account tiller

# need to setup persistent volume claim infra
k create ns monitoring
helm --tiller-namespace tiller install --namespace monitoring --name prometheus stable/prometheus \
 --set alertmanager.persistentVolume.enabled=false \
 --set server.persistentVolume.enabled=false

k create ns nginx-ingress
helm --tiller-namespace tiller install --namespace nginx-ingress stable/nginx-ingress --name nginx-ingress \
 --set rbac.create=true \
 --set controller.stats.enabled=true \
 --set controller.metrics.enabled=true \
 --set controller.service.type=NodePort \
 --set controller.service.nodePorts.http=30080 \
 --set controller.service.nodePorts.https=30443

k create ns cert-manager
helm repo update
helm install --tiller-namespace tiller --namespace cert-manager --name cert-manager stable/cert-manager

k apply -f clusterissuer.yml

k create ns prod
k -n prod apply nginx-healthcheck/deployment-service.yaml
# at this point you should go configure the LB to point at :31654/health so the droplets look healthy

helm --tiller-namespace tiller install --namespace monitoring --name grafana stable/grafana
k -n monitoring apply -f grafana-ingress.yml
