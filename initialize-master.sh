#!/usr/bin/env bash
set -e
# TODO figure this out better,
rm -rf /mnt/volume_sfo2_02/etcd
rm /var/lib/etcd
ln -fs /mnt/volume_sfo2_02/etcd/data /var/lib/etcd
mkdir -p /mnt/volume_sfo2_02/etcd/data  # TODO make this always use the correct name for the volume
kubeadm init --config kubeadm-config.yml

# install calico
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml

