#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" != "--yes" ]]; then
  echo 'Ce script modifie le système : K3s sera installé via le script officiel.'
  echo 'Réservé à une VM Ubuntu dédiée, neuve, avec accès sudo.'
  echo 'Relire le script puis lancer : bash scripts/install_k3s.sh --yes'
  exit 2
fi

if [[ "$(id -u)" -eq 0 ]]; then
  echo 'Exécuter comme utilisateur normal disposant de sudo (pas directement root).' >&2
  exit 1
fi
if ! command -v sudo >/dev/null || ! command -v curl >/dev/null; then
  echo 'sudo et curl sont nécessaires.' >&2
  exit 1
fi
if [[ -e /etc/rancher/k3s/k3s.yaml ]] || command -v k3s >/dev/null 2>&1 || systemctl is-active --quiet k3s 2>/dev/null; then
  echo 'K3s semble déjà installé. Arrêt pour éviter une modification non prévue.' >&2
  exit 1
fi
if [[ ! -r /etc/os-release ]]; then
  echo 'OS non détecté : installation annulée.' >&2
  exit 1
fi
# shellcheck disable=SC1091
source /etc/os-release
if [[ "${ID:-}" != 'ubuntu' ]]; then
  echo 'Ce script guidé est réservé à Ubuntu.' >&2
  exit 1
fi

installer="$(mktemp /tmp/5g-telcoops-k3s.XXXXXX)"
trap 'rm -f "$installer"' EXIT
printf 'Téléchargement du script officiel K3s...\n'
curl --fail --silent --show-error --location https://get.k3s.io --output "$installer"
if [[ ! -s "$installer" ]]; then
  echo 'Script téléchargé vide : arrêt.' >&2
  exit 1
fi
bash -n "$installer"
echo 'Installation K3s (serveur mono-nœud, Flannel par défaut, Traefik désactivé)...'
# Version épinglable pour la reproductibilité : exporter K3S_VERSION avant d'exécuter.
if [[ -n "${K3S_VERSION:-}" ]]; then
  sudo env K3S_VERSION="$K3S_VERSION" INSTALL_K3S_EXEC='server --disable=traefik' sh "$installer"
else
  sudo env INSTALL_K3S_EXEC='server --disable=traefik' sh "$installer"
fi

echo 'Installation terminée. Vérification initiale :'
sudo k3s kubectl get nodes -o wide
cat <<'END'
Prochaines commandes :
  bash scripts/check_cluster.sh
  bash scripts/smoke_test.sh

Pour voir la version installée : sudo k3s --version
Pour consulter le script officiel : https://docs.k3s.io/quick-start
END
