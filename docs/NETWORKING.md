# Points réseau à comprendre avant le Core 5G

- **N2 (gNB ↔ AMF)** : NGAP sur SCTP ; vérifier le support du nœud, du CNI et de la politique réseau.
- **N3 (gNB ↔ UPF)** : GTP-U/UDP 2152 ; vérifier les adresses effectivement joignables et les routes.
- **N4 (SMF ↔ UPF)** : PFCP/UDP 8805 ; vérifier que l'association SMF-UPF se crée.
- **N6 (UPF ↔ réseau de données)** : IP, routage et éventuellement NAT. Une PDU session réussie ne prouve pas la connectivité externe.
- **Multus** : outil de réseaux supplémentaires pour Pods à étudier en V0.3 si les interfaces/réseaux du laboratoire l'exigent ; ne pas l'ajouter par réflexe avant de tester le chemin le plus simple.

Pour V0.1, **Flannel est conservé** afin de valider les bases Kubernetes. Le réseau Core 5G sera examiné séparément en V0.2/V0.3.
