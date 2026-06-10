# ADR-001: Hybrid Memory Architecture

## Document Status

**ADR:** ADR-001
**Title:** Hybrid Memory Architecture
**Work Packet:** WP-E0-003 — Record Canonical Architecture Decision
**Status:** Accepted
**Date:** 2026-06-10

---

## 1. Decision

Founder Decision OS will use a hybrid memory architecture with these rules:

1. PostgreSQL or Supabase is the canonical system of record.
2. pgvector is the built-in semantic memory layer inside PostgreSQL.
3. Qdrant is an optional external retrieval accelerator.
4. Supabase Storage stores raw evidence files and attachments.
5. AI workflows may interpret, summarize, compare, classify, and recommend, but they do not become the source of truth.

---

## 2. Context

Founder Decision OS is intended to preserve the founder's reasoning over time, not merely generate ideas in transient chat sessions.

The system must support:

- auditable decision history,
- structured founder planning records,
- evidence-backed reasoning,
- semantic retrieval across prior records,
- future SaaS productization,
- and optional acceleration layers without loss of trust boundaries.

The architecture therefore needs to preserve canonical ownership while still supporting memory retrieval and AI-assisted workflows.

---

## 3. Problem

If semantic retrieval or AI output becomes the effective source of truth, the system loses auditability and becomes difficult to verify.

If external vector infrastructure becomes mandatory too early, local development, migrations, tests, and future product maintenance become more fragile than necessary.

The architecture must solve for both:

- strong truth ownership,
- and practical semantic memory support.

---

## 4. Chosen Architecture

### 4.1 Canonical Record Layer

All durable business records live in PostgreSQL or Supabase tables.

This includes:

- founder profiles,
- workspaces and organizations,
- business ideas,
- assumptions,
- evidence,
- experiments,
- decisions,
- reviews,
- risks,
- tasks,
- scorecards,
- prompts,
- summaries,
- memory items,
- and audit-related metadata.

Canonical IDs, foreign keys, timestamps, and tenant scope are owned here.

### 4.2 Built-In Memory Layer

pgvector is enabled inside PostgreSQL and used for semantic retrieval against canonical memory records.

The system stores:

- memory items,
- embeddings,
- embedding metadata,
- and source references back to canonical records.

This keeps the default semantic memory story inside the same trust boundary as the source data.

### 4.3 Optional Retrieval Accelerator

Qdrant may be used as an external retrieval accelerator when enabled.

Qdrant does not own business truth.

Qdrant collections must mirror canonical PostgreSQL-backed memory items and carry references to canonical record IDs.

If Qdrant is unavailable or disabled, the system must still function with PostgreSQL and pgvector alone.

### 4.4 Raw Evidence Storage

Supabase Storage stores raw evidence files such as documents, screenshots, transcripts, or attachments.

Storage objects are referenced by canonical records in PostgreSQL.

The object store does not replace the structured record that describes what the file is, why it matters, and what business entity it belongs to.

### 4.5 AI Workflow Layer

AI-generated summaries, classifications, recommendations, reports, and memory enrichments are derived artifacts.

They must be stored as records linked back to source records where practical.

AI output may help interpretation, but it does not replace canonical source data.

---

## 5. Data Flow

1. The founder or a workflow creates or updates canonical records in PostgreSQL or Supabase.
2. Relevant records are converted into memory items and embeddings in PostgreSQL.
3. When enabled, selected memory items are mirrored into Qdrant for retrieval acceleration.
4. AI workflows retrieve canonical records and memory context.
5. AI workflows produce summaries, reports, or recommendations that are stored as derived records.
6. Decisions and follow-up actions are recorded back into canonical PostgreSQL tables.

---

## 6. Trust Boundaries

### 6.1 GitHub Boundary

GitHub is the implementation workflow source of truth for issues, commits, branches, pull requests, and review notes.

### 6.2 Database Boundary

PostgreSQL or Supabase is the product data source of truth.

It owns canonical records and should be sufficient to reconstruct system state.

### 6.3 Vector Boundary

pgvector is part of the database trust boundary because it lives inside PostgreSQL.

Qdrant is outside the canonical boundary and must be treated as a mirror.

### 6.4 AI Boundary

AI services are advisory and generative layers.

They may transform or interpret records but may not silently redefine what is true in the system.

### 6.5 Storage Boundary

Supabase Storage holds files, not canonical meaning.

Meaning and relationships remain in PostgreSQL records.

---

## 7. Consequences

### Positive Consequences

- Canonical records remain auditable and relational.
- Semantic retrieval is available without requiring an external vector service.
- Qdrant can be introduced later without destabilizing the core system.
- The design supports both personal use and future SaaS productization.
- AI outputs remain reviewable artifacts instead of silent truth mutations.

### Tradeoffs

- Some data may be duplicated between PostgreSQL and Qdrant when acceleration is enabled.
- Sync logic adds operational complexity.
- Embedding pipelines must preserve canonical references carefully.
- AI workflows must be disciplined about citation and source linking.

---

## 8. Rejected Alternatives

### 8.1 Qdrant-First Truth Ownership

Rejected because it would externalize truth ownership, complicate local development, and weaken relational integrity.

### 8.2 AI Output As Canonical State

Rejected because generated output is not sufficiently deterministic or auditable to serve as truth.

### 8.3 File Store As Primary Memory

Rejected because raw files do not provide structured relationships, validation state, or decision lineage on their own.

---

## 9. Implementation Rules Derived From This ADR

1. Every semantic memory record must reference a canonical PostgreSQL record.
2. Every Qdrant payload must reference canonical PostgreSQL IDs.
3. Core startup, migrations, seed data, verification, and tests must work without Qdrant.
4. AI outputs must be stored as records and should cite or reference canonical inputs where practical.
5. Supabase Storage usage must be modeled through canonical attachment or evidence records.

---

## 10. Status Rule

This ADR is canonical unless replaced by a later accepted ADR.
