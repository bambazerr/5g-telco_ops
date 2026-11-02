#!/usr/bin/env bash
set -uo pipefail

printf '\n=== 5G TelcoOps / Preflight (lecture seule) ===\n'
if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  source /etc/os-release
  printf 'OS           : %s\n' "${PRETTY_NAME:-Inconnu}"
else
  printf 'OS           : non détecté\n'
fi
printf 'Architecture : %s\n' "$(uname -m)"
printf 'CPU          : %s vCPU\n' "$(nproc)"
if [[ -r /proc/meminfo ]]; then
  mem_kb=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
  printf 'RAM          : %s MiB\n' "$((mem_kb / 1024))"
fi
printf 'Stockage /   :\n'
df -h / | tail -n 1
printf '\nCommandes :\n'
for cmd in sudo curl systemctl git k3s helm kubectl; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '  [OK] %-10s %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf '  [--] %-10s absent\n' "$cmd"
  fi
done
printf '\nVérifications :\n'
if [[ "${ID:-}" != "ubuntu" ]]; then
  printf '[INFO] Ubuntu recommandé pour ce guide (OS détecté : %s).\n' "${ID:-inconnu}"
fi
if (( $(nproc) < 4 )); then
  printf '[INFO] 4 vCPU recommandés pour notre laboratoire.\n'
fi
if [[ -n "${mem_kb:-}" ]] && (( mem_kb < 8 * 1024 * 1024 )); then
  printf '[INFO] 8 Go de RAM conseillés pour commencer.\n'
fi
if command -v systemctl >/dev/null 2>&1; then
  if systemctl is-active --quiet k3s 2>/dev/null; then
    printf '[INFO] Service K3s déjà actif : NE PAS relancer l’installation.\n'
  else
    printf '[INFO] Service K3s non détecté comme actif.\n'
  fi
fi
printf '\nAucune modification du système effectuée.\n'
