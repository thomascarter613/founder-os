# Founder Decision OS Foundation MVP Definition

## Document Status

**Document:** MVP Definition
**Product:** Founder Decision OS
**Work Packet:** WP-E0-002 — Define Foundation MVP Scope
**Status:** Draft v0.1
**Scope Type:** Foundation MVP
**Canonical Architecture:** PostgreSQL/Supabase source of truth with pgvector built in and optional Qdrant acceleration

---

## 1. MVP Framing

The Founder Decision OS MVP is a foundation product, not a throwaway prototype.

Its purpose is to create a durable system of record for founder planning, idea evaluation, evidence capture, experiments, decisions, and memory retrieval.

The MVP must be good enough to:

- run locally,
- define the canonical schema,
- capture the founder decision process in structured records,
- support semantic memory inside PostgreSQL,
- support optional retrieval acceleration without making it mandatory,
- provide verification and test paths,
- and establish a repository shape that can become a real product.

The MVP is not complete when it merely demonstrates a concept.

The MVP is complete when the repository, schema, scripts, docs, and optional-module boundaries make the system maintainable, testable, and extensible.

---

## 2. Product Boundary

The Foundation MVP includes:

- repository structure,
- product and architecture documentation,
- local development setup,
- canonical PostgreSQL and Supabase schema,
- tenant-aware core records,
- pgvector memory support,
- optional Qdrant sync scaffolding,
- verification scripts,
- seed data,
- SQL tests,
- smoke tests where practical,
- prompt and workflow documentation,
- and minimal productizable app and worker scaffolds.

The Foundation MVP does not require:

- a polished production web interface,
- a full auth product experience,
- billing,
- complete multi-tenant SaaS administration,
- advanced analytics dashboards,
- or mandatory external AI runtime execution.

---

## 3. Must-Have Scope

The following capabilities are required for MVP completion.

### 3.1 Canonical Data Foundation

- PostgreSQL or Supabase is the canonical source of truth.
- Core schema exists for founder planning, ideation, evidence, experiments, decisions, risks, tasks, tags, and attachments.
- Schema includes organization and workspace boundaries where appropriate.
- Migrations apply in order without schema drift.

### 3.2 Memory Foundation

- pgvector is enabled when available and documented when not available.
- Memory items and embeddings reference canonical PostgreSQL records.
- Embedding metadata records provider, model, and dimension.
- Retrieval logic preserves tenant and workspace boundaries.

### 3.3 Optional Module Safety

- Qdrant is optional.
- AI worker execution is optional.
- Report generation is optional.
- Web app runtime is optional.
- Optional modules must not break database boot, migrations, seed, verification, or core tests when disabled.

### 3.4 Verification Foundation

- Seed data exists and matches the schema.
- Verification SQL exists.
- Shell scripts exist for migration, seed, reset, smoke, and verification flows.
- SQL tests exist for schema, seed data, relationships, views, memory, RLS, and Qdrant queue behavior where relevant.

### 3.5 Documentation Foundation

- Product charter exists.
- MVP definition exists.
- Feature matrix exists.
- ADR-001 exists.
- Productization path exists.
- Docs describe source-of-truth ownership clearly and do not claim nonexistent files or schema.

### 3.6 Repository Productization Foundation

- Repository commands are documented and real.
- Shared package and scaffold boundaries exist for future productization.
- CI references actual commands and files only.
- Backup and export scripts exist with safety checks.

---

## 4. Should-Have Scope

The following capabilities materially improve the MVP but are not required for the first completion state.

- Minimal web scaffold with honest no-op behavior when disabled.
- Minimal worker scaffold with explicit feature gating.
- Prompt library organized for reuse.
- Exported schemas and fixtures.
- More detailed operational docs and troubleshooting guides.
- Additional SQL and smoke-test depth beyond the baseline acceptance suite.

---

## 5. Could-Have Scope

The following capabilities are future-facing and may be added during or after the Foundation MVP if they do not destabilize the core system.

- richer founder dashboards,
- advanced retrieval ranking,
- automated AI report generation,
- hosted Supabase deployment instructions,
- background embedding jobs,
- richer attachment workflows,
- collaboration features,
- advisor review views,
- venture portfolio support,
- and full SaaS tenancy administration.

---

## 6. Explicit Non-Goals For This MVP

The Foundation MVP is not trying to be:

- a finished SaaS product,
- a complete UI application,
- an autonomous startup builder,
- a mandatory AI execution system,
- a Qdrant-first architecture,
- or a replacement for canonical database records with generated text.

AI may interpret, summarize, compare, and recommend.

AI may not become the source of truth.

---

## 7. Required Feature Flags

The repository must define these feature flags exactly:

```env
ENABLE_QDRANT=false
ENABLE_AI_WORKER=false
ENABLE_REPORT_GENERATION=false
ENABLE_WEB_APP=false
ENABLE_SUPABASE_STORAGE=true
ENABLE_PGVECTOR=true
```

Rules:

- `ENABLE_QDRANT=false` means Qdrant scripts and workers must skip safely.
- `ENABLE_AI_WORKER=false` means no background AI runtime is required for core verification.
- `ENABLE_REPORT_GENERATION=false` means reports may be modeled without becoming required runtime behavior.
- `ENABLE_WEB_APP=false` means the repository may ship web scaffolding without requiring UI startup for core completion.
- `ENABLE_SUPABASE_STORAGE=true` means storage support is part of the MVP architecture, but raw files still do not become canonical truth.
- `ENABLE_PGVECTOR=true` means semantic memory is part of the baseline architecture and should be enabled in supported environments.

---

## 8. Completion Criteria

The Foundation MVP is complete only when all of the following are true:

1. GitHub issues, branches, commits, and pull requests reflect actual implementation history.
2. Product and architecture docs exist and match the real repository.
3. Local development commands map to real files and real scripts.
4. Migrations apply in order.
5. Seed data inserts successfully.
6. Verification SQL passes, or failures are fixed before completion.
7. Optional modules remain optional.
8. Core operation does not require Qdrant.
9. AI outputs are modeled as records, never as canonical truth.
10. The repository can serve as the starting point for a productized future system.

---

## 9. Failure Conditions

The MVP is not complete if any of the following are true:

- the schema is only partially modeled,
- docs promise files or commands that do not exist,
- migrations and seed data drift from the documented model,
- Qdrant is required for core functionality,
- AI outputs are treated as truth without canonical record links,
- verification is skipped without honest status labeling,
- or the repository cannot support further incremental work through issues and PRs.

---

## 10. Definition of Done For WP-E0-002

WP-E0-002 is complete when:

- this document exists,
- `docs/product/feature-matrix.md` exists,
- must-have, should-have, and could-have scope are explicit,
- feature-flag rules are explicit,
- optional modules are defined as optional and safe when disabled,
- and MVP completion criteria are unambiguous.
