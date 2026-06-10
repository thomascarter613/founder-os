# ADR-001 Decision Record: Use PostgreSQL, pgvector, and Optional Qdrant

## Decision Summary

Founder Decision OS will use:

- PostgreSQL or Supabase as the canonical source of truth,
- pgvector as the default semantic memory layer,
- optional Qdrant as a retrieval accelerator,
- and AI as a derived interpretation layer rather than a truth owner.

---

## Why This Decision Exists

The product needs durable records, semantic recall, and future scalability without sacrificing auditability.

Using PostgreSQL as the canonical core preserves:

- relational integrity,
- tenant-aware boundaries,
- timestamped history,
- and future productization flexibility.

Using pgvector inside PostgreSQL provides semantic retrieval without requiring an external vector platform for the base system.

Using Qdrant only as an optional mirror allows future scale and experimentation without turning retrieval infrastructure into the system of record.

---

## Operating Rules

1. Canonical product records live in PostgreSQL or Supabase.
2. Memory items and embeddings are linked to canonical records.
3. Qdrant payloads must reference canonical PostgreSQL IDs.
4. AI outputs are stored as records but do not become authoritative truth.
5. Raw evidence files live in storage but are described and governed by canonical database records.

---

## Repository Linkage

The full architecture decision is documented in:

- [ADR-001 Hybrid Memory Architecture](../architecture/ADR-001-hybrid-memory-architecture.md)

This decision record exists to give the repository a concise, local reference entry under `docs/decisions/`.
