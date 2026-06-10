# Founder Decision OS Roadmap

## Document Status

**Document:** Product Roadmap
**Work Packet:** WP-E0-004 — Define Productization Path
**Status:** Draft v0.1
**Date:** 2026-06-10

---

## 1. Roadmap Principle

The roadmap prioritizes foundation before polish.

The system must become structurally correct before it becomes visually complete or operationally ambitious.

---

## 2. Milestone Sequence

### M0: Planning Complete

Focus:

- product charter,
- MVP scope,
- ADR-001,
- productization path,
- roadmap,
- and issue structure.

Exit condition:

- product direction and canonical architecture are documented clearly enough to guide repository implementation.

### M1: Runnable Database Foundation

Focus:

- repository skeleton,
- environment files,
- Docker services,
- Makefile,
- Supabase config,
- extensions,
- identity and tenancy,
- and founder decision schema foundations.

Exit condition:

- local database foundation is runnable and the canonical schema direction is established.

### M2: Memory Foundation

Focus:

- pgvector memory schema,
- embedding scripts,
- optional Qdrant sync scaffolding,
- and retrieval discipline.

Exit condition:

- semantic memory is modeled and optional Qdrant acceleration is isolated correctly.

### M3: Verification Foundation

Focus:

- storage policies,
- RLS,
- indexes,
- views,
- triggers,
- seed data,
- verification SQL,
- and tests.

Exit condition:

- the repository can verify schema correctness and core behavior with honest execution status.

### M4: Productization Foundation

Focus:

- prompt library,
- documentation system,
- app and worker scaffolds,
- packages,
- schemas,
- fixtures,
- scripts,
- and CI.

Exit condition:

- the repository is structured like a product foundation, not just a database prototype.

### M5: Foundation MVP Release

Focus:

- full verification,
- defect fixes,
- final consistency audit,
- final verification report,
- and release packaging.

Exit condition:

- the repository reaches a credible Foundation MVP release state.

---

## 3. Near-Term Work Priorities

1. Complete E0 and E1 so architecture, command conventions, and repository layout are explicit.
2. Build the canonical Supabase and PostgreSQL schema in E2 and E3.
3. Add memory and optional Qdrant scaffolding in E4 and E5.
4. Add verification, policies, and test depth in E6 and E10.
5. Complete prompt, docs, scaffold, and CI layers in E7, E8, E9, and E11.
6. Run final integration and release verification in E12.

---

## 4. Product Maturity Path

### Stage A: Personal Founder Decision Ledger

The founder uses the system directly to document ideas, assumptions, evidence, and decisions.

### Stage B: Internal Venture Operating Tool

The system supports repeatable internal workflows and structured review by collaborators or advisors.

### Stage C: Hosted Product Candidate

The repository gains the operational rigor required for hosted deployment and supportable growth.

### Stage D: Multi-Tenant Product Platform

The system supports multiple customers or organizations with stronger isolation, policy, and support tooling.

### Stage E: AI Memory System

The system matures into a structured AI memory platform with strict provenance, retrieval, and derived-record rules.

---

## 5. Roadmap Guardrails

The roadmap must not be distorted by:

- premature UI work that outruns the schema,
- making optional services mandatory,
- treating generated text as truth,
- skipping verification to accelerate visible output,
- or adding commands that do not map to real repository files.

---

## 6. Success Definition

The roadmap is succeeding when each milestone leaves behind:

- clearer truth ownership,
- more runnable infrastructure,
- more reliable verification,
- better founder decision support,
- and stronger productization readiness without architectural rework.
