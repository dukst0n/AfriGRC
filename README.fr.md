# AfriGRC

**Une plateforme GRC modulaire, open source et assistée par IA, pour aider les organisations d'Afrique de l'Ouest à protéger les données personnelles et à respecter les lois locales.**

🇬🇧 [English version](README.md)

> **Statut : pré-alpha / phase de conception.** Rien n'est encore prêt pour la production. Pays pilote : **Sénégal**. Le contenu juridique **ne constitue pas un avis juridique** et doit être validé par un juriste local qualifié.

---

## Sommaire

1. [Le problème](#1-le-problème)
2. [La solution](#2-la-solution)
3. [Cadre juridique ciblé](#3-cadre-juridique-ciblé)
4. [Fonctionnalités prévues](#4-fonctionnalités-prévues)
5. [Architecture](#5-architecture)
6. [Des agents IA encadrés](#6-des-agents-ia-encadrés)
7. [Pourquoi cette approche](#7-pourquoi-cette-approche)
8. [Maintenance et mises à jour](#8-maintenance-et-mises-à-jour)
9. [Structure du dépôt (cible)](#9-structure-du-dépôt-cible)
10. [Feuille de route](#10-feuille-de-route)
11. [Notes techniques et limites](#11-notes-techniques-et-limites)
12. [Contribuer](#12-contribuer)
13. [Licence](#13-licence)
14. [Contact](#14-contact)

---

## 1. Le problème

Les PME et les écoles d'Afrique de l'Ouest traitent de plus en plus de données personnelles : dossiers d'élèves, données de santé, photos, paiements (dont Mobile Money), groupes WhatsApp, tableurs dans le cloud. Pourtant :

- Les lois de protection des données existent dans la plupart des pays de la région, mais elles sont **mal connues et rarement appliquées**, et plusieurs sont en cours de révision.
- La plupart des organisations n'ont **ni RSSI, ni DPO, ni service informatique**.
- Les suites GRC commerciales (Microsoft Purview, OneTrust, etc.) sont **coûteuses, centrées sur l'anglais, exclusivement cloud**, et n'intègrent pas **le droit local**.
- Envoyer des données sensibles vers des plateformes SaaS étrangères pose des questions de **transfert transfrontalier** et de souveraineté.
- Les écoles gèrent des données de **mineurs**, ce qui élève les enjeux juridiques et éthiques.

## 2. La solution

AfriGRC assemble des composants open source éprouvés, comme des briques Lego, autour d'un cœur de gouvernance ([CISO Assistant](https://github.com/intuitem/ciso-assistant-community)), et y ajoute :

- **Des packs juridiques locaux** : lois nationales et textes de la CEDEAO traduits en exigences, contrôles techniques, preuves et modèles de documents, avec mapping vers ISO 27001 / 27701 et d'autres référentiels.
- **Une couche d'IA encadrée, locale par défaut**, qui prépare analyses d'écart, plans d'action, brouillons et alertes, toujours avec sources et toujours sous validation humaine.
- **Un profil « Essentiel » léger** qui tient dans **16 Go de RAM** (on-premise, Ubuntu Server), avec une trajectoire vers un SaaS multi-clients pour les grandes institutions.

**Ce qu'AfriGRC est :** une plateforme pour *évaluer, guider, documenter, surveiller et alerter* sur tout le cycle de vie de la protection des données (« 360° de pilotage de la conformité et de la protection »).

**Ce qu'AfriGRC n'est pas :** il ne chiffre pas vos données, ne les sauvegarde pas et ne bloque pas les fuites à votre place. Il indique ce qui manque, pourquoi c'est important juridiquement et comment corriger. Il ne remplace ni un juriste, ni un DPO, ni un auditeur de sécurité.

> AfriGRC est un projet indépendant. Il n'est ni affilié, ni soutenu par CISO Assistant ou tout autre composant intégré, et n'en est pas un fork.

## 3. Cadre juridique ciblé

| Niveau | Texte | Remarques |
|---|---|---|
| Régional | Acte additionnel CEDEAO A/SA.1/01/10 (2010) relatif à la protection des données à caractère personnel | Principes, droits des personnes, autorités nationales, transferts |
| Continental | Convention de Malabo de l'Union africaine (2014) | Pack prévu |
| Pays pilote | **Sénégal** : loi n° 2008-12 sur la protection des données à caractère personnel et son décret d'application ; contrôle par la **CDP** (Commission de Protection des Données Personnelles) | En vigueur à la fin 2026 ; un projet de réforme serait en cours. Textes voisins (cybercriminalité, transactions électroniques, cryptologie) à évaluer |
| Sénégal, en cours | Nouvelle législation sur la cybersécurité et les infrastructures d'information critiques (2026) | Statut à vérifier ; concerne surtout les grandes institutions |
| Références internationales | ISO/IEC 27001, 27002, 27701, 27005, NIST CSF, CIS Controls | Les mappings citent uniquement les numéros de clauses, jamais le texte protégé |
| Pays suivants | Côte d'Ivoire, Bénin, Togo, Mali, Burkina Faso, Niger, Guinée, Ghana, Nigeria… | Un pack par pays, même méthode |

Chaque pack juridique porte : le texte source, **sa version et sa date**, la **juridiction**, la **date et l'auteur de la dernière relecture juridique**, et des identifiants stables (URN) pour chaque exigence. Les packs sont versionnés : une réforme législative produit une nouvelle version du pack plutôt qu'une réécriture.

## 4. Fonctionnalités prévues

Le périmètre « 360° » s'organise en 8 domaines :

| # | Domaine | Ce qu'apporte AfriGRC |
|---|---|---|
| 1 | Gouvernance | Politiques, rôles (DPO / référent données), charte informatique |
| 2 | Cartographie des données | Inventaire des données et des traitements, registre des traitements |
| 3 | Base légale et droits | Consentement, information, gestion des demandes d'accès / suppression |
| 4 | Risques et AIPD | Analyse de risques simplifiée (ISO 27005 / EBIOS RM), analyse d'impact allégée |
| 5 | Mesures de sécurité | Checklist guidée : MFA, sauvegardes, chiffrement, mots de passe, mises à jour, départ des employés |
| 6 | Incidents et violations | Procédure, registre, modèle de notification et délais |
| 7 | Tiers et transferts | Registre des fournisseurs (cloud, messagerie, Mobile Money), alertes sur les transferts hors pays |
| 8 | Sensibilisation et preuves | Mini-formations, attestations, tableau de bord de conformité, rapports générés par l'IA |

**Deux niveaux de produit**

- **Pack Essentiel** (PME, écoles) : questionnaire de maturité, analyse d'écart par pays, plan d'action priorisé à 90 jours, kit de modèles de documents, workflow des formalités auprès du régulateur (ex. déclarations et autorisations CDP au Sénégal), tableau de bord.
- **Pack Avancé** (organisations plus matures) : découverte automatisée des données, scans techniques, collecte automatique de preuves, détection.

**Contenu spécifique aux écoles :** données de mineurs et consentement parental, durées de conservation des dossiers scolaires, vidéosurveillance et biométrie, groupes de messagerie de classe, paiement des frais en ligne.

## 5. Architecture

```
┌──────────────────────── COUCHE IA (orchestrateur) ──────────────────────────┐
│ Agents : Conformité │ Risques │ Données │ Détection │ Audit │ Gardien-IA    │
│ LLM local (Ollama / llama.cpp) + RAG (pgvector) + garde-fous                │
└───────────────▲──────────────────────────────────────────▲──────────────────┘
       bus d'événements (Redis Streams / NATS) + API / adaptateurs normalisés
┌───────────────┴───────┐ ┌──────────────────┐ ┌────────────┴─────────────────┐
│ GOUVERNANCE           │ │ DONNÉES          │ │ DÉTECTION & POSTURE          │
│ CISO Assistant        │ │ Presidio, Tika   │ │ Trivy, Prowler, Lynis,       │
│ (référentiels, risques│ │ Fides*, catalogue*│ │ Wazuh*, Greenbone*, OPA     │
│ audits, preuves)      │ │                  │ │                              │
└───────────────────────┘ └──────────────────┘ └──────────────────────────────┘
┌─────────────────────── SOCLE DE SÉCURITÉ ───────────────────────────────────┐
│ Caddy/Traefik │ SSO + MFA (natif ; Keycloak en multi-clients) │ Secrets     │
│ PostgreSQL │ Stockage objet / logs immuables │ sauvegardes restic │ Observab.│
└─────────────────────────────────────────────────────────────────────────────┘
                       (* = optionnel, profil à la demande)
```

**Le contrat Lego.** Un composant n'entre dans la plateforme que s'il fournit : une image conteneur durcie, le SSO (OIDC) ou une gestion d'authentification documentée, une API ou des webhooks, des logs structurés vers le collecteur central et un healthcheck.

**Modèle de données pivot.** Chaque composant normalise sa sortie vers :
`Actif → Catégorie de données → Contrôle → Preuve → Constat → Risque → Action`
(schéma JSON, inspiré d'OCSF / ECS). Chaque composant est placé derrière un **adaptateur** léger : si l'API amont change, on corrige un seul endroit.

**Profils de déploiement (Docker Compose, Ubuntu Server LTS)**

| Profil | Contenu | RAM indicative* |
|---|---|---|
| `core` | Reverse proxy, CISO Assistant, PostgreSQL, authentification | ~3–4 Go |
| `ai` | Orchestrateur, Redis, LLM local (3–8B, quantifié) | ~4–6 Go |
| `scan` | Presidio, Trivy, Lynis, Prowler (à la demande / batch) | ~0,5–1 Go |
| `detect` | Pile Wazuh (plus lourde) | ~3–4 Go |

\* Estimations à valider par benchmark. Objectif : **profil Essentiel (`core` + `ai` + `scan`) confortablement dans 16 Go**, système compris.

**Parcours de déploiement**

| | On-premise (PME, écoles) | SaaS (grandes institutions) |
|---|---|---|
| Exécution | Docker Compose, une instance par client | Kubernetes ou instance isolée par client |
| Isolation | Physique (une machine par client) | Base ou schéma séparé par client |
| Identité | Comptes locaux, MFA | SSO Keycloak + MFA |
| IA | Petit LLM local | Modèle local plus gros / GPU / hybride anonymisé |
| Images | **Mêmes images**, configuration différente | **Mêmes images**, configuration différente |

## 6. Des agents IA encadrés

L'IA **propose, l'humain valide**. Les agents sont des assistants, pas des décideurs.

| Agent | Rôle |
|---|---|
| Conformité | Associe les preuves aux contrôles, fait l'analyse d'écart (loi / ISO), prépare les rapports d'audit |
| Risques | Propose des scénarios et des scores à partir des constats (EBIOS RM / ISO 27005) |
| Données | Aide à classifier les données, alimente la cartographie, rédige des brouillons de registre et d'AIPD |
| Détection | Trie les alertes, corrèle avec les CVE, réduit le bruit |
| Audit continu | Collecte les preuves, détecte la dérive de configuration |
| Gardien-IA | Surveille les briques de la plateforme elle-même : images, SBOM, CVE, signatures, secrets exposés |

**Garde-fous**

- **Local par défaut** : le LLM par défaut tourne sur la machine du client. Tout modèle externe est optionnel et ne reçoit que des prompts anonymisés.
- **Ancré dans des sources** : les réponses citent leurs sources (article de loi, contrôle, preuve). Si les sources sont insuffisantes, l'agent le dit.
- **Lecture seule par défaut** : aucune remédiation autonome. Toute action d'écriture exige une validation humaine explicite et est journalisée.
- **Filtrage entrées/sorties** : retrait des données personnelles et défenses contre l'injection de prompt (les documents sont des entrées non fiables).
- **Traçabilité** : chaque recommandation enregistre ses entrées, la version du modèle et celle du prompt.
- **Tests réguliers** selon l'OWASP LLM Top 10 (ex. garak, promptfoo).

**Format d'une alerte :** sévérité × sensibilité des données × exposition, puis *pourquoi*, *preuve*, *référence légale / normative*, *étapes de remédiation*, *effort estimé*, *responsable suggéré*. Envoi via Apprise, ntfy, Mattermost, e-mail ou Telegram.

## 7. Pourquoi cette approche

- **Ne pas réinventer la GRC.** CISO Assistant gère déjà référentiels, risques, preuves et audits. Notre valeur ajoutée : **le droit local, le contexte local et l'automatisation locale**.
- **Des données, pas des forks.** Le contenu juridique est livré sous forme de bibliothèques (fichiers de données) importées dans l'application amont. Pas de fork : les mises à jour restent simples et les correctifs de sécurité continuent d'arriver.
- **Commencer petit, grandir selon le besoin.** On démarre avec gouvernance + packs juridiques locaux + IA locale ; on ajoute des briques seulement quand un cas d'usage réel l'exige.
- **Souveraineté et coût.** Open source, on-premise, LLM local : abordable pour les PME et les écoles, et les données restent dans l'organisation.
- **Périmètre honnête.** AfriGRC pilote et documente la protection ; il ne prétend pas être un DLP ni une suite de sécurité des postes.

## 8. Maintenance et mises à jour

**Rien ne se met à jour tout seul.** Les images sont épinglées par version (et par digest). C'est volontaire : une mise à jour automatique non testée sur une plateforme de sécurité est elle-même un risque.

| Étape | Outil | Automatisé ? |
|---|---|---|
| Détecter les nouvelles versions amont | Renovate ou Diun | Oui (alerte / PR) |
| Scanner les nouvelles images | Trivy | Oui |
| Correctifs de sécurité de l'OS | `unattended-upgrades` | Oui |
| Sauvegarde avant mise à jour | `pg_dump` + restic | Oui |
| Tests de santé et d'adaptateurs après mise à jour | healthchecks + suite de tests | Oui |
| **Décider d'appliquer et valider** | mainteneur | **Non, volontairement** |

**Procédure de mise à jour (`update.sh`, prévu) :** geler les écritures → sauvegarde (hors de la machine) → snapshot (si virtualisé) → changer la version épinglée → tirer et scanner l'image → relancer la seule brique concernée → exécuter les tests → en cas d'échec, retour arrière par restauration de la sauvegarde.

**Notes**
- Les migrations de base de données sont en général irréversibles ; le retour arrière passe par la restauration de la sauvegarde.
- Les packs juridiques vivent dans Git avec leur propre cycle de vie et sont réimportés après chaque montée de version amont.
- Rythme : correctifs de sécurité sous quelques jours (après test), versions mineures chaque mois, versions majeures planifiées et testées d'abord sur un clone.
- Les composants Wazuh doivent être mis à jour ensemble et dans le bon ordre.

## 9. Structure du dépôt (cible)

```
afrigrc/
├── README.md                 # English
├── README.fr.md              # Français
├── LICENSE
├── CONTRIBUTING.md
├── SECURITY.md               # Politique de divulgation des vulnérabilités
├── CODE_OF_CONDUCT.md
├── docs/
│   ├── architecture/         # Schémas, contrat Lego, modèle de données pivot
│   ├── adr/                  # Décisions d'architecture
│   ├── threat-model/         # Modèles de menaces plateforme et IA
│   └── legal-notes/          # Sources, notes d'interprétation, journal de relecture
├── packs/
│   ├── _template/            # Squelette d'un pack pays
│   ├── ecowas/
│   │   └── acte-additionnel-2010/
│   └── sn/                   # Sénégal (pilote)
│       ├── loi-2008-12/      # Bibliothèque de référentiel (YAML)
│       ├── mappings/         # → ISO 27001/27701, NIST CSF
│       ├── templates/        # Registres, politiques, consentements, procédure de violation
│       ├── questionnaires/   # Questionnaires de maturité PME et école
│       └── workflows/        # Formalités auprès du régulateur (CDP)
├── deploy/
│   ├── compose/              # Profils core / ai / scan / detect
│   ├── ubuntu/               # Durcissement et installation (Ubuntu Server LTS)
│   ├── backup/               # Scripts restic + pg_dump
│   └── tenants/              # Exemples de configuration par client
├── adapters/                 # Un adaptateur léger par brique → modèle pivot
├── agents/                   # Agents IA, prompts, garde-fous, jeux d'évaluation
├── tools/                    # Validation de packs, conversion Excel→YAML, lint
├── tests/                    # Tests des adaptateurs, packs et agents
└── .github/                  # CI (lint, Trivy, validation des packs), modèles d'issues
```

## 10. Feuille de route

| Phase | Durée cible | Livrable |
|---|---|---|
| 0 | 2 semaines | Socle : durcissement Ubuntu, reverse proxy, authentification, PostgreSQL, sauvegardes, observabilité |
| 1 | 4–6 semaines | CISO Assistant + **pack Sénégal v0.1** + pack CEDEAO ; questionnaire de maturité ; modèles de documents |
| 2 | 4 semaines | LLM local + RAG : analyse d'écart, plan d'action et génération de rapports (supervisés) |
| 3 | 4 semaines | Première brique technique (Trivy ou Prowler) alimentant des preuves automatiques via un adaptateur |
| 4 | 4 semaines | Découverte de données (Presidio + Tika) avec reconnaisseurs ouest-africains (pièces d'identité, formats de téléphone, RIB, Mobile Money) |
| 5 | 4–6 semaines | Workflow d'incidents, registre des fournisseurs, registre des traitements / AIPD |
| 6 | Continu | Packs pays supplémentaires, profil SaaS multi-clients, pentest externe, préparation ISO 27001 |

**Indicateurs de succès :** temps de préparation d'un audit, % de contrôles couverts par des preuves automatiques, taux de faux positifs de classification, délai moyen de détection, nombre d'organisations ayant terminé un plan à 90 jours.

## 11. Notes techniques et limites

- **Pas un avis juridique.** Les packs sont des interprétations à faire valider par un juriste local. Le régime sénégalais est en transition (projet de réforme et législation cybersécurité en cours) ; les packs sont versionnés en conséquence.
- **Périmètre.** AfriGRC pilote et documente la protection. Il ne remplace ni un DLP, ni la protection des postes, ni les sauvegardes, ni un DPO humain.
- **Matériel.** OS cible : **Ubuntu Server LTS**. Profil Essentiel conçu pour 16 Go de RAM, 8 vCPU recommandés, SSD de 500 Go. Sur CPU, un modèle 7B quantifié ne génère que quelques tokens par seconde : suffisant pour des rapports asynchrones, pas pour un chat temps réel. Un GPU est optionnel.
- **Chiffres de RAM** : ce sont des estimations. Utiliser des `mem_limit` par conteneur et des profils à la demande pour les outils lourds.
- **Réalité des petites organisations.** Beaucoup de PME et d'écoles utilisent Google Workspace / Microsoft 365 et des PC non administrés : la « détection » privilégie donc les vérifications de configuration SaaS (MFA, partage public, comptes d'anciens employés) et les questionnaires guidés plutôt que les agents et les serveurs.
- **Un snapshot n'est pas une sauvegarde.** En test sous VM, exportez de vraies sauvegardes hors de la VM.
- **Licences.** Vérifier la licence de chaque composant intégré. Par exemple, CISO Assistant Community est sous AGPL-3.0, ce qui a des implications pour une offre SaaS. Les composants « fair-code » non OSI sont évités lorsque la pureté open source compte.
- **Limites de l'IA.** Les modèles peuvent se tromper. Les sorties sont des brouillons à relire, et la qualité en français et dans les contextes locaux doit être évaluée sur nos propres jeux de test.

## 12. Contribuer

Les contributions sont les bienvenues, en particulier de la part de :

- **Juristes et DPO** (relecture juridique des packs, notes d'interprétation)
- **Praticiens de la sécurité et de la GRC** (contrôles, mappings, modèles)
- **Développeurs** (adaptateurs, agents, outillage, packaging)
- **Enseignants et responsables d'établissements** (exigences propres aux écoles)
- **Traducteurs** (français, anglais, langues locales pour les contenus destinés aux utilisateurs)

Pour démarrer :

1. Ouvrez une issue pour discuter de votre idée ou choisissez une issue `good first issue`.
2. Forkez le dépôt, créez une branche et faites votre modification.
3. Lancez le validateur de packs et les tests (`tools/`, `tests/`).
4. Ouvrez une pull request. Toute modification juridique doit citer le texte source, les numéros d'articles et la date.

Merci de lire `CONTRIBUTING.md` et `CODE_OF_CONDUCT.md` (à venir). Pour les failles de sécurité, **n'ouvrez pas d'issue publique** : suivez `SECURITY.md`.

## 13. Licence

*À confirmer avant la première version.* Proposition :

- **Code** (adaptateurs, agents, outils, déploiement) : à décider (ex. Apache-2.0 ou AGPL-3.0).
- **Packs juridiques, modèles et documentation :** Creative Commons (ex. CC BY-SA 4.0), en gardant à l'esprit que les textes de loi et les normes ISO ont leur propre statut : les packs citent uniquement les numéros de clauses ISO et ne reproduisent pas le texte des normes.
- Les composants tiers conservent leurs propres licences.

## 14. Contact

**Uk'iva DAPAM**
**DUKSTON**
_ukiva.dapam@dukston.com_
_https://www.linkedin.com/in/ukivadapam-cybersecurity/_
