# Founder Decision OS Feature Matrix

## Document Status

**Document:** Feature Matrix
**Product:** Founder Decision OS
**Work Packet:** WP-E0-002 — Define Foundation MVP Scope
**Status:** Draft v0.1

---

## 1. Matrix

| Capability | Tier | Required In Foundation MVP | Canonical Owner | Feature Flag | Notes |
| --- | --- | --- | --- | --- | --- |
| GitHub issue and PR workflow | Must-have | Yes | GitHub | N/A | Implementation history must live in GitHub. |
| Product charter | Must-have | Yes | Repository docs | N/A | Defines product identity and boundaries. |
| MVP definition | Must-have | Yes | Repository docs | N/A | Defines completion scope. |
| Architecture decision records | Must-have | Yes | Repository docs | N/A | Records canonical system design. |
| Local development setup | Must-have | Yes | Repository scripts | N/A | Must map to actual commands and files. |
| PostgreSQL canonical schema | Must-have | Yes | PostgreSQL or Supabase | N/A | Canonical business records live here. |
| Organization and workspace scope | Must-have | Yes | PostgreSQL or Supabase | N/A | Required for future productization and isolation. |
| Founder planning entities | Must-have | Yes | PostgreSQL or Supabase | N/A | Founder profile, idea, evidence, decision, risk, task, and related records. |
| pgvector semantic memory | Must-have | Yes | PostgreSQL or Supabase | `ENABLE_PGVECTOR` | Built-in memory layer tied to canonical records. |
| Supabase Storage support | Must-have | Yes | Supabase Storage | `ENABLE_SUPABASE_STORAGE` | Stores raw evidence files without becoming truth owner. |
| Qdrant acceleration | Must-have architecture, optional runtime | No | Qdrant mirror of PostgreSQL records | `ENABLE_QDRANT` | Optional accelerator only. |
| AI worker runtime | Should-have | No | AI outputs stored in PostgreSQL | `ENABLE_AI_WORKER` | Disabled by default; core system must still work. |
| Report generation runtime | Should-have | No | AI outputs stored in PostgreSQL | `ENABLE_REPORT_GENERATION` | Optional generation pipeline. |
| Web application runtime | Should-have | No | Repository app scaffold | `ENABLE_WEB_APP` | Scaffold may exist without being required. |
| Worker application scaffold | Should-have | No | Repository worker scaffold | `ENABLE_AI_WORKER` | Safe no-op behavior when disabled. |
| Verification SQL | Must-have | Yes | Repository scripts | N/A | Required for honest verification. |
| SQL tests | Must-have | Yes | Repository tests | N/A | Covers schema, seed, relationships, views, memory, and RLS. |
| Smoke tests | Must-have where practical | Yes | Repository tests | N/A | Honest skip or block status when environment prevents execution. |
| Seed data | Must-have | Yes | PostgreSQL or Supabase | N/A | Must match the live schema. |
| Backup and export scripts | Should-have | No | Repository scripts | N/A | Productization support. |
| CI workflows | Should-have | No | GitHub Actions | N/A | Must reference real commands only. |
| Rich founder UI | Could-have | No | Future web app | `ENABLE_WEB_APP` | Not required for the foundation. |
| Billing and SaaS administration | Could-have | No | Future SaaS layer | N/A | Explicitly out of MVP scope. |

---

## 2. Tier Definitions

### Must-have

Required for the repository to count as a real Foundation MVP.

### Should-have

Important productization support that improves the repository but is not required for first completion.

### Could-have

Useful future capabilities that should not delay the canonical foundation.

---

## 3. Optional Module Rules

Optional capabilities must follow these rules:

1. They must be guarded by explicit flags.
2. They must not break local database startup when disabled.
3. They must not break migrations when disabled.
4. They must not break seed data when disabled.
5. They must not break verification scripts when disabled.
6. They must not make AI output or Qdrant data canonical truth.

---

## 4. Source-of-Truth Summary

- GitHub is the source of truth for implementation workflow.
- PostgreSQL or Supabase is the source of truth for product records.
- pgvector is the built-in semantic retrieval layer.
- Qdrant is only an optional mirror and accelerator.
- AI outputs are records derived from canonical data, not replacements for it.
