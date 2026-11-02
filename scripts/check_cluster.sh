#!/usr/bin/env bash
set -euo pipefail

if ! command -v k3s >/dev/null 2>&1; then
  echo 'K3s n’est pas installé (commande k3s absente).' >&2
  exit 1
fi
if ! command -v sudo >/dev/null 2>&1; then
  echo 'sudo est requis pour accéder au kubeconfig K3s sans le copier.' >&2
  exit 1
fi
printf '\n=== 5G TelcoOps / Cluster ===\n'
sudo k3s kubectl cluster-info
sudo k3s kubectl get nodes -o wide
printf '\n=== Pods kube-system ===\n'
sudo k3s kubectl get pods -n kube-system
printf '\n=== Ressources cluster ===\n'
sudo k3s kubectl get namespaces
printf '\nVérification des nœuds Ready :\n'
sudo k3s kubectl wait --for=condition=Ready nodes --all --timeout=90s
printf '\n[OK] K3s répond et tous les nœuds sont Ready.\n'
