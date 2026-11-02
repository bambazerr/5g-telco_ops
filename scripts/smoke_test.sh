#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if ! command -v k3s >/dev/null 2>&1; then
  echo 'K3s absent : installer et vérifier le cluster d’abord.' >&2
  exit 1
fi
if [[ "${1:-}" == '--cleanup' ]]; then
  echo 'Suppression du namespace de démonstration telcoops-demo uniquement...'
  sudo k3s kubectl delete namespace telcoops-demo --ignore-not-found
  exit 0
fi
if [[ $# -gt 0 ]]; then
  echo 'Usage: bash scripts/smoke_test.sh [--cleanup]' >&2
  exit 2
fi

sudo k3s kubectl apply -f "$repo_root/infrastructure/smoke-test/namespace.yaml"
sudo k3s kubectl apply -f "$repo_root/infrastructure/smoke-test/deployment.yaml"
sudo k3s kubectl apply -f "$repo_root/infrastructure/smoke-test/service.yaml"
echo 'Attente de la disponibilité du Deployment Nginx...'
sudo k3s kubectl rollout status deployment/web-demo -n telcoops-demo --timeout=180s
printf '\n=== Pods et Service ===\n'
sudo k3s kubectl get pods,svc -n telcoops-demo -o wide
cat <<'END'

[OK] Déploiement de démonstration terminé (pas encore Open5GS).
Pour voir le fonctionnement : sudo k3s kubectl describe deployment web-demo -n telcoops-demo
Pour nettoyer : bash scripts/smoke_test.sh --cleanup
END
