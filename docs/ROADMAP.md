# Feuille de route — 5G TelcoOps

| Étape | Livraison | Preuve / critère de validation |
|---|---|---|
| V0.1 | VM Ubuntu, K3s et smoke test de Pod/Deployment/Service | Nœud Ready et Deployment Available |
| V0.2 | Helm Open5GS + UERANSIM 5G SA | Registration UE, PDU session, échange IP (traces et résultats) |
| V0.3 | Réseau Kubernetes/télécom : N2 SCTP, N3 GTP-U, N4 PFCP ; Multus si nécessaire | Flux et routes observés, diagnostic des erreurs réseau |
| V0.4 | GitOps avec Argo CD | Changement versionné et synchronisé avec succès |
| V0.5 | CI GitHub Actions + validation Helm/configurations | PR invalide bloquée automatiquement |
| V0.6 | Observabilité Prometheus/Grafana et collecte de logs | Dashboard et alerte vérifiable |
| V0.7 | Tests de panne et reprise | Temps de récupération mesuré, limites documentées |

## Approche

1. Comprendre chaque commande et déploiement.
2. Documenter les problèmes réellement rencontrés (pas seulement les cas heureux).
3. Tester le Core avant d'ajouter Argo CD et Grafana pour éviter de masquer les problèmes N2/N3/N4.
4. Éviter d'affirmer la disponibilité des sessions existantes après redémarrage d'une fonction sans test explicite.
5. Ne pas confondre le moteur d'analyse **5G TraceLab** et l'infrastructure **5G TelcoOps** : intégration possible plus tard, projets distincts.
