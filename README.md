# 5G TelcoOps

**Cloud-Native 5G Core · Kubernetes · DevOps · GitOps**

Projet personnel d'apprentissage : construire une plateforme de laboratoire Open5GS + UERANSIM, puis automatiser son déploiement, ses tests et sa supervision.

> **État : V0.1 — Préparation de l'environnement Kubernetes.** Cette version ne déploie **pas encore** de cœur 5G et ne prétend pas valider une procédure NAS/PDU. Les étapes seront validées sur une VM personnelle avant la suite.

## Pourquoi ce projet ?

- Comprendre Kubernetes et les contraintes des fonctions réseau 5G conteneurisées.
- Apprendre Helm, GitOps/Argo CD, CI/CD et monitoring dans un cas d'usage télécom.
- Automatiser des tests de registration UE, de session PDU et de trafic IP à terme.
- Étudier N2/SCTP, N3/GTP-U, N4/PFCP et les limites de l'orchestration vis-à-vis de l'état des sessions.

## Laboratoire conseillé

- **Une VM Ubuntu Server 24.04 LTS** personnelle et distincte de Labtainer (22.04 LTS possible).
- **4 vCPU**, **8 Go de RAM** pour commencer (12 Go de préférence pour davantage de fonctions et les outils de supervision), **50 Go de disque** sur SSD si possible.
- Connexion Internet et accès `sudo`.
- Architecture AMD64/x86_64 privilégiée ; autres architectures à vérifier pour les images 5G.

Ces ressources sont des valeurs pratiques proposées pour notre laboratoire, pas le minimum officiel de K3s. Pour un laboratoire 5G complet et du monitoring, les besoins peuvent augmenter.

## Étape 1 — Préparer la VM

Depuis le répertoire du dépôt :

```bash
bash scripts/preflight.sh
```

Le script affiche le système, les ressources et les outils disponibles **sans modifier la VM**.

## Étape 2 — Installer K3s (sur cette VM dédiée uniquement)

Lire les scripts avant de les lancer :

```bash
less scripts/install_k3s.sh
bash scripts/install_k3s.sh --yes
```

Ce script **installe K3s**, télécharge le script officiel depuis `get.k3s.io`, puis l'exécute avec `sudo`. Il désactive Traefik (non nécessaire à notre première étape) et conserve le CNI Flannel par défaut. Ne pas l'exécuter sur une VM de production, sur Labtainer, ou sur un cluster existant.

K3s fournit `kubectl` via son installation. Valider :

```bash
sudo k3s kubectl get nodes -o wide
sudo k3s kubectl get pods -A
bash scripts/check_cluster.sh
```

## Étape 3 — Déployer une application de démonstration Kubernetes

C'est une application web **Nginx de test** pour apprendre Deployment, Pod et Service ClusterIP. Ce n'est **pas** Open5GS.

```bash
bash scripts/smoke_test.sh
```

Pour la retirer :

```bash
bash scripts/smoke_test.sh --cleanup
```

## Réussite V0.1

- [ ] VM dédiée créée et prérequis compris.
- [ ] `sudo k3s kubectl get nodes` montre un nœud `Ready`.
- [ ] Les Pods systèmes nécessaires sont en état de marche.
- [ ] Le déploiement `telcoops-demo` est disponible.
- [ ] Je comprends la différence entre Pod, Deployment et Service.

## Plan des prochaines versions

Voir [`docs/ROADMAP.md`](docs/ROADMAP.md). La V0.2 visera un déploiement Open5GS + UERANSIM **validé de bout en bout**, à partir d'un chart Helm existant, avec des valeurs de configuration reproductibles.

## Sources

- K3s : https://docs.k3s.io/quick-start
- Ressources K3s : https://docs.k3s.io/installation/requirements
- Gradiant 5G Charts : https://github.com/Gradiant/5g-charts
- Exemple Open5GS + UERANSIM : https://gradiant.github.io/5g-charts/open5gs-ueransim-gnb.html

## Sécurité / publication

- Ne jamais committer `~/.kube/config`, des tokens K3s, des clés, des identifiants d'abonnés réels ou des logs internes du travail.
- Les identifiants futurs de SIM seront **fictifs** et propres au laboratoire local.
- Les scripts de cette version sont pour un environnement isolé d'apprentissage.
