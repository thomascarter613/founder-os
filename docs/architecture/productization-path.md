# Founder Decision OS Productization Path

## Document Status

**Document:** Productization Path
**Work Packet:** WP-E0-004 — Define Productization Path
**Status:** Draft v0.1
**Date:** 2026-06-10

---

## 1. Purpose

Founder Decision OS starts as a personal founder planning system, but it is being built from the beginning as a productizable platform.

This document defines the staged path from:

- personal founder use,
- to internal operational use,
- to hosted product readiness,
- to multi-tenant SaaS,
- to AI-memory infrastructure.

The architecture should evolve by extension, not by replacement.

---

## 2. Non-Negotiable Continuity Rules

Every phase must preserve these rules:

1. PostgreSQL or Supabase remains the canonical source of truth.
2. pgvector remains the built-in semantic memory layer.
3. Qdrant remains optional and derivative when enabled.
4. AI workflows remain advisory and derived, not canonical truth owners.
5. GitHub remains the implementation workflow source of truth.

---

## 3. Phase 1: Personal Founder System

### Goal

Help a single founder choose, test, and document what business to start.

### Characteristics

- single primary operator,
- one default organization,
- one default workspace,
- local development focus,
- founder-facing records for ideas, assumptions, evidence, experiments, and decisions,
- and semantic recall across the founder's own history.

### Required Outcomes

- the system runs locally,
- core schema exists,
- seed data supports realistic founder workflows,
- memory items link to canonical records,
- and founder reasoning becomes reviewable over time.

---

## 4. Phase 2: Internal AIC Tool

### Goal

Use the system as an internal Applied Innovation Corp operating tool for venture ideation, advisory support, and structured business research.

### Characteristics

- multiple internal operators,
- multiple workspaces,
- higher expectations for repeatable operating procedures,
- stronger verification and documentation requirements,
- and support for advisor or collaborator review flows.

### Required Evolution

- clearer tenant and workspace rules,
- stronger role and review assumptions,
- more durable verification scripts,
- export and backup workflows,
- and better documentation for repeatable use.

---

## 5. Phase 3: SaaS-Readiness

### Goal

Prepare the repository and architecture so it can become a hosted product without a foundational rewrite.

### Characteristics

- honest app and worker scaffolds,
- environment separation,
- CI workflows,
- typed shared packages,
- operational scripts,
- storage policies,
- RLS,
- auditability,
- and support for hosted Supabase deployment paths.

### Required Evolution

- production-safe environment management,
- stronger policy enforcement,
- package boundaries,
- fixture and schema discipline,
- and documented trust boundaries for hosted operation.

---

## 6. Phase 4: Multi-Tenant Product

### Goal

Serve multiple organizations and founders in a single product platform.

### Characteristics

- organization-scoped and workspace-scoped data access,
- stronger permission modeling,
- per-tenant operational isolation,
- migration discipline,
- and customer-safe administration patterns.

### Required Evolution

- fully enforced tenant-aware RLS,
- admin and support workflows,
- safer backup and restore flows,
- scalable indexing and queue operations,
- and higher confidence monitoring and audit trails.

---

## 7. Phase 5: AI-Memory Infrastructure

### Goal

Evolve the system into a durable AI-assisted memory platform for founder reasoning, business formation, and future venture intelligence workflows.

### Characteristics

- richer embedding and retrieval workflows,
- AI summary and report pipelines,
- stronger citation and provenance rules,
- optional background workers,
- optional retrieval acceleration,
- and memory policies that preserve trust boundaries.

### Required Evolution

- explicit source-reference requirements,
- derived-record lifecycle policies,
- retrieval-event logging,
- re-embedding workflows,
- and stricter controls over how AI outputs influence decisions.

---

## 8. Upgrade Path

The intended upgrade path is:

1. Local repository plus Docker-backed services.
2. Local Supabase-compatible workflows.
3. Hosted Supabase project configuration.
4. Product-ready deployment practices.
5. Multi-tenant hosted operations.

The goal is to reuse the same canonical schema and repository patterns throughout this progression.

---

## 9. Design Implications

This path requires the repository to adopt product-ready habits early:

- issue-driven work packets,
- explicit architecture decisions,
- feature flags for optional modules,
- tenant-aware schema conventions,
- honest verification discipline,
- and file and command inventories that remain aligned with reality.

---

## 10. Risks If This Path Is Ignored

If the repository is built only as a personal prototype, the likely failure modes are:

- schema redesign before productization,
- broken command and script assumptions,
- loss of trust boundaries,
- external services becoming accidental hard dependencies,
- and AI outputs drifting into de facto truth ownership.

---

## 11. Decision

Founder Decision OS will be built as a personal-first but productizable platform, with each layer designed so the next phase extends the current system rather than replacing it.
