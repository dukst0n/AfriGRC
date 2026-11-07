# AfriGRC

**A modular, open-source, AI-assisted GRC platform that helps West African organizations protect personal data and comply with local law.**

🇫🇷 [Version française](README.fr.md)

> **Status: pre-alpha / design phase.** Nothing here is production-ready yet. Pilot country: **Senegal**. Legal content is **not legal advice** and must be validated by a qualified local lawyer.

---

## Table of contents

1. [The problem](#1-the-problem)
2. [The solution](#2-the-solution)
3. [Targeted legal framework](#3-targeted-legal-framework)
4. [Planned features](#4-planned-features)
5. [Architecture](#5-architecture)
6. [Supervised AI agents](#6-supervised-ai-agents)
7. [Why this approach](#7-why-this-approach)
8. [Maintenance and updates](#8-maintenance-and-updates)
9. [Repository structure (target)](#9-repository-structure-target)
10. [Roadmap](#10-roadmap)
11. [Technical notes and limitations](#11-technical-notes-and-limitations)
12. [Contributing](#12-contributing)
13. [License](#13-license)
14. [Contact](#14-contact)

---

## 1. The problem

Small and medium-sized businesses (SMEs) and schools in West Africa process more and more personal data: student records, health information, photos, payments (including Mobile Money), WhatsApp groups, cloud spreadsheets. At the same time:

- Data protection laws exist in most countries of the region but are **poorly known and rarely applied**, and several are being revised.
- Most organizations have **no CISO, no DPO and no IT department**.
- Commercial GRC and compliance suites (Microsoft Purview, OneTrust and similar) are **expensive, English-centric, cloud-only**, and do not encode **local law**.
- Sending sensitive data to foreign SaaS platforms raises **cross-border transfer** and sovereignty concerns.
- Schools handle data of **minors**, which carries higher legal and ethical stakes.

## 2. The solution

AfriGRC assembles proven open-source components, like Lego bricks, around a governance core ([CISO Assistant](https://github.com/intuitem/ciso-assistant-community)), and adds:

- **Local legal packs**: national laws and ECOWAS texts translated into requirements, technical controls, evidence and document templates, mapped to ISO 27001 / 27701 and other standards.
- **A supervised, local-first AI layer** that prepares gap analyses, action plans, drafts and alerts, always with sources and always under human validation.
- **A lightweight "Essential" profile** that runs on **16 GB of RAM** (on-premise, Ubuntu Server), with a path to a multi-tenant SaaS for larger institutions.

**What AfriGRC is:** a platform to *assess, guide, document, monitor and alert* across the data protection lifecycle ("360° of compliance and protection steering").

**What AfriGRC is not:** it does not encrypt your data, back it up or block leaks by itself. It tells you what is missing, why it matters legally, and how to fix it. It is not a replacement for a lawyer, a DPO or a security auditor.

> AfriGRC is an independent project. It is not affiliated with, endorsed by or a fork of CISO Assistant or any other component it integrates.

## 3. Targeted legal framework

| Level | Text | Notes |
|---|---|---|
| Regional | ECOWAS Supplementary Act A/SA.1/01/10 (2010) on personal data protection | Principles, data subject rights, national authorities, transfers |
| Continental | African Union Malabo Convention (2014) | Pack planned |
| Pilot country | **Senegal**: Law No. 2008-12 on personal data protection and its implementing decree; supervised by the **CDP** (Commission de Protection des Données Personnelles) | In force as of late 2026; a reform bill is reportedly pending. Related texts (cybercrime, electronic transactions, cryptology) to be evaluated |
| Senegal, in progress | New cybersecurity / critical information infrastructure legislation (2026) | Status to verify; mostly relevant to large institutions |
| International references | ISO/IEC 27001, 27002, 27701, 27005, NIST CSF, CIS Controls | Mappings reference clause numbers only, never copyrighted text |
| Next countries | Côte d'Ivoire, Benin, Togo, Mali, Burkina Faso, Niger, Guinea, Ghana, Nigeria… | One pack per country, same method |

Every legal pack carries: source text, **version and date**, **jurisdiction**, **last legal review date and reviewer**, and stable identifiers (URNs) for each requirement. Packs are versioned so a law reform produces a new pack version rather than a rewrite.

## 4. Planned features

The "360°" scope is organized into 8 domains:

| # | Domain | What AfriGRC provides |
|---|---|---|
| 1 | Governance | Policies, roles (DPO / data protection officer), IT charter |
| 2 | Data mapping | Inventory of data and processing activities, processing register |
| 3 | Legal basis and rights | Consent, notices, access / deletion request handling |
| 4 | Risks and DPIA | Simplified risk analysis (ISO 27005 / EBIOS RM), lightweight impact assessment |
| 5 | Security measures | Guided checklist: MFA, backups, encryption, passwords, patching, offboarding |
| 6 | Incidents and breaches | Procedure, register, notification template and deadlines |
| 7 | Third parties and transfers | Vendor register (cloud, messaging, Mobile Money), cross-border transfer alerts |
| 8 | Awareness and evidence | Short trainings, attestations, compliance dashboard, AI-generated reports |

**Two product tiers**

- **Essential pack** (SMEs, schools): maturity questionnaire, country-specific gap analysis, 90-day prioritized action plan, document template kit, regulator-formalities workflow (e.g. CDP declarations and authorizations in Senegal), dashboard.
- **Advanced pack** (more mature organizations): automated data discovery, technical scans, automated evidence collection, detection.

**School-specific content:** minors' data and parental consent, retention of school records, video surveillance and biometrics, class messaging groups, online fee payments.

## 5. Architecture

```
┌──────────────────────── AI LAYER (orchestrator) ────────────────────────────┐
│ Agents: Compliance │ Risk │ Data │ Detection │ Audit │ AI-Guardian          │
│ Local LLM (Ollama / llama.cpp) + RAG (pgvector) + guardrails                │
└───────────────▲──────────────────────────────────────────▲──────────────────┘
       event bus (Redis Streams / NATS) + normalized APIs / adapters
┌───────────────┴───────┐ ┌──────────────────┐ ┌────────────┴─────────────────┐
│ GOVERNANCE            │ │ DATA             │ │ DETECTION & POSTURE          │
│ CISO Assistant        │ │ Presidio, Tika   │ │ Trivy, Prowler, Lynis,       │
│ (frameworks, risks,   │ │ Fides*, catalog* │ │ Wazuh*, Greenbone*, OPA      │
│ audits, evidence)     │ │                  │ │                              │
└───────────────────────┘ └──────────────────┘ └──────────────────────────────┘
┌─────────────────────── SECURITY FOUNDATION ─────────────────────────────────┐
│ Caddy/Traefik │ SSO + MFA (built-in; Keycloak for multi-tenant) │ Secrets   │
│ PostgreSQL │ Object storage / immutable logs │ restic backups │ Observability│
└─────────────────────────────────────────────────────────────────────────────┘
                          (* = optional, on-demand profile)
```

**The Lego contract.** A component joins the platform only if it provides: a hardened container image, SSO (OIDC) or a documented auth story, an API or webhooks, structured logs to the central collector, and a healthcheck.

**Pivot data model.** Every component normalizes its output to:
`Asset → Data category → Control → Evidence → Finding → Risk → Action`
(JSON schema, inspired by OCSF / ECS). Each component sits behind a thin **adapter**, so an upstream API change is fixed in one place.

**Deployment profiles (Docker Compose, Ubuntu Server LTS)**

| Profile | Contents | Indicative RAM* |
|---|---|---|
| `core` | Reverse proxy, CISO Assistant, PostgreSQL, auth | ~3–4 GB |
| `ai` | Orchestrator, Redis, local LLM (3–8B, quantized) | ~4–6 GB |
| `scan` | Presidio, Trivy, Lynis, Prowler (on-demand/batch) | ~0.5–1 GB |
| `detect` | Wazuh stack (heavier) | ~3–4 GB |

\* Estimates to be validated by benchmark. Target: **Essential profile (`core` + `ai` + `scan`) comfortably within 16 GB**, including OS overhead.

**Deployment paths**

| | On-premise (SMEs, schools) | SaaS (large institutions) |
|---|---|---|
| Runtime | Docker Compose, one instance per client | Kubernetes or isolated instance per client |
| Isolation | Physical (one machine per client) | Separate database/schema per tenant |
| Identity | Local accounts, MFA | Keycloak SSO + MFA |
| AI | Small local LLM | Larger local model / GPU / anonymized hybrid |
| Images | **Same images**, configuration differs | **Same images**, configuration differs |

## 6. Supervised AI agents

The AI **proposes, a human validates**. Agents are assistants, not decision-makers.

| Agent | Role |
|---|---|
| Compliance | Maps evidence to controls, performs gap analysis (law / ISO), drafts audit reports |
| Risk | Suggests scenarios and scores from findings (EBIOS RM / ISO 27005) |
| Data | Helps classify data, feeds the data map, drafts processing registers and DPIAs |
| Detection | Triages alerts, correlates with CVEs, reduces noise |
| Continuous audit | Collects evidence, detects configuration drift |
| AI-Guardian | Monitors the platform's own bricks: images, SBOM, CVEs, signatures, exposed secrets |

**Guardrails**

- **Local-first**: the default LLM runs on the client's own machine. Any external model is opt-in and only receives anonymized prompts.
- **Retrieval-grounded**: answers cite their sources (law article, control, evidence). If sources are insufficient, the agent says so.
- **Read-only by default**: no autonomous remediation. Any write action requires explicit human approval and is logged.
- **Input/output filtering**: PII scrubbing and prompt-injection defenses (documents are untrusted input).
- **Auditability**: every recommendation records its inputs, model version and prompt version.
- **Regular testing** against the OWASP LLM Top 10 (e.g. garak, promptfoo).

**Alert format:** severity × data sensitivity × exposure, then *why*, *evidence*, *legal / standard reference*, *remediation steps*, *estimated effort*, *suggested owner*. Delivery via Apprise, ntfy, Mattermost, email or Telegram.

## 7. Why this approach

- **Don't reinvent GRC.** CISO Assistant already handles frameworks, risks, evidence and audits. Our value is **local law, local context and local automation**.
- **Data, not forks.** Legal content ships as libraries (data files) imported into the upstream application. No fork means upstream updates stay simple and security patches keep flowing.
- **Start small, grow by need.** Begin with governance + local legal packs + local AI; add bricks only when a real use case demands them.
- **Sovereignty and cost.** Open source, on-premise, local LLM: affordable for SMEs and schools, and data stays in the organization.
- **Honest scope.** AfriGRC steers and documents protection; it does not pretend to be a DLP or an endpoint security suite.

## 8. Maintenance and updates

**Nothing updates itself.** Images are pinned by version (and digest). This is deliberate: an untested automatic update on a security platform is itself a risk.

| Step | Tooling | Automated? |
|---|---|---|
| Detect new upstream versions | Renovate or Diun | Yes (alert / PR) |
| Scan new images | Trivy | Yes |
| OS security patches | `unattended-upgrades` | Yes |
| Pre-update backup | `pg_dump` + restic | Yes |
| Post-update health and adapter tests | healthchecks + test suite | Yes |
| **Decide to apply and validate** | maintainer | **No, by design** |

**Update procedure (`update.sh`, planned):** freeze writes → backup (off-machine) → snapshot (if virtualized) → bump pinned version → pull and scan → restart the one brick → run health/adapter tests → rollback by restoring the backup if anything fails.

**Notes**
- Database migrations usually cannot be reversed; rollback = restore the backup.
- Legal packs live in Git with their own lifecycle and are re-imported after upstream upgrades.
- Cadence: security fixes within days (after testing), minor versions monthly, major versions planned and tested on a clone first.
- Wazuh components must be upgraded together and in the right order.

## 9. Repository structure (target)

```
afrigrc/
├── README.md                 # English
├── README.fr.md              # Français
├── LICENSE
├── CONTRIBUTING.md
├── SECURITY.md               # Vulnerability disclosure policy
├── CODE_OF_CONDUCT.md
├── docs/
│   ├── architecture/         # Diagrams, Lego contract, pivot data model
│   ├── adr/                  # Architecture decision records
│   ├── threat-model/         # Platform and AI threat models
│   └── legal-notes/          # Sources, interpretation notes, review log
├── packs/
│   ├── _template/            # Skeleton for a new country pack
│   ├── ecowas/
│   │   └── acte-additionnel-2010/
│   └── sn/                   # Senegal (pilot)
│       ├── loi-2008-12/      # Framework library (YAML)
│       ├── mappings/         # → ISO 27001/27701, NIST CSF
│       ├── templates/        # Registers, policies, consent forms, breach procedure
│       ├── questionnaires/   # SME and school maturity questionnaires
│       └── workflows/        # Regulator formalities (CDP)
├── deploy/
│   ├── compose/              # core / ai / scan / detect profiles
│   ├── ubuntu/               # Hardening and install scripts (Ubuntu Server LTS)
│   ├── backup/               # restic + pg_dump scripts
│   └── tenants/              # Per-client configuration examples
├── adapters/                 # One thin adapter per brick → pivot data model
├── agents/                   # AI agents, prompts, guardrails, evaluation sets
├── tools/                    # Pack validation, Excel→YAML conversion, linting
├── tests/                    # Adapter, pack and agent tests
└── .github/                  # CI (lint, Trivy, pack validation), issue templates
```

## 10. Roadmap

| Phase | Target duration | Deliverable |
|---|---|---|
| 0 | 2 weeks | Foundation: Ubuntu hardening, reverse proxy, auth, PostgreSQL, backups, observability |
| 1 | 4–6 weeks | CISO Assistant + **Senegal pack v0.1** + ECOWAS pack; maturity questionnaire; document templates |
| 2 | 4 weeks | Local LLM + RAG: gap analysis, action plan and report generation (supervised) |
| 3 | 4 weeks | First technical brick (Trivy or Prowler) feeding automated evidence through an adapter |
| 4 | 4 weeks | Data discovery (Presidio + Tika) with West African recognizers (national IDs, phone formats, RIB, Mobile Money) |
| 5 | 4–6 weeks | Incident workflow, vendor register, processing register / DPIA |
| 6 | Ongoing | Additional country packs, multi-tenant SaaS profile, external pentest, ISO 27001 readiness |

**Success indicators:** time to prepare an audit, % of controls covered by automatic evidence, classification false-positive rate, mean time to detect, number of organizations completing a 90-day plan.

## 11. Technical notes and limitations

- **Not legal advice.** Packs are interpretations to be validated by a local lawyer. Senegal's regime is in transition (reform bill and cybersecurity legislation pending); packs are versioned accordingly.
- **Scope.** AfriGRC steers and documents protection. It does not replace DLP, endpoint protection, backups or a human DPO.
- **Hardware.** Target OS: **Ubuntu Server LTS**. Essential profile designed for 16 GB RAM, 8 vCPU recommended, 500 GB SSD. On CPU, a 7B quantized model generates only a few tokens per second: fine for asynchronous reports, not for real-time chat. A GPU is optional.
- **RAM figures** are estimates. Use `mem_limit` per container and on-demand profiles for heavy tools.
- **Small-organization reality.** Many SMEs and schools run on Google Workspace / Microsoft 365 and unmanaged PCs, so "detection" favors SaaS configuration checks (MFA, public sharing, ex-employee accounts) and guided questionnaires over agents and servers.
- **Snapshots are not backups.** If you test in a VM, export real backups off the VM.
- **Licensing.** Verify the license of every integrated component. For example, CISO Assistant Community is AGPL-3.0, which has implications for SaaS offerings. Non-OSI "fair-code" components are avoided where open-source purity matters.
- **AI limits.** Models can be wrong. Outputs are drafts that require review, and quality in French and local contexts must be evaluated on our own test sets.

## 12. Contributing

Contributions are welcome, especially from:

- **Lawyers and DPOs** (legal review of packs, interpretation notes)
- **Security and GRC practitioners** (controls, mappings, templates)
- **Developers** (adapters, agents, tooling, packaging)
- **Educators and school administrators** (school-specific requirements)
- **Translators** (French, English, and local languages for end-user content)

How to start:

1. Open an issue to discuss your idea or pick a `good first issue`.
2. Fork the repository, create a branch, and make your change.
3. Run the pack validator and tests (`tools/`, `tests/`).
4. Open a pull request. Legal changes must cite the source text, article numbers and date.

Please read `CONTRIBUTING.md` and `CODE_OF_CONDUCT.md` (to be added). For security issues, **do not open a public issue**: follow `SECURITY.md`.

## 13. License

*To be confirmed before the first release.* Proposed:

- **Code** (adapters, agents, tools, deployment): to be decided (e.g. Apache-2.0 or AGPL-3.0).
- **Legal packs, templates and documentation:** Creative Commons (e.g. CC BY-SA 4.0), keeping in mind that legal source texts and ISO standards have their own status: packs reference ISO clause numbers only and do not reproduce standard text.
- Third-party components keep their own licenses.

## 14. Contact

**Uk'iva DAPAM**
**DUKSTON**
_ukiva.dapam@dukston.com_
_https://www.linkedin.com/in/ukivadapam-cybersecurity/_