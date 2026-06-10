# Founder Decision OS Schema Conventions

## Document Status

**Document:** Schema Conventions
**Work Packet:** WP-E2-004 — Add Shared Table Conventions
**Status:** Draft v0.1
**Date:** 2026-06-10

---

## 1. Purpose

This document defines the default table-shape rules for Founder Decision OS.

The goal is to keep migrations consistent as the schema grows across founder planning, ideation, evidence, decisions, memory, security, and audit layers.

---

## 2. Primary Rules

### 2.1 Canonical IDs

- Use `uuid` primary keys.
- Default UUID generation should use `extensions.gen_random_uuid()`.
- Foreign keys should reference canonical UUIDs directly.

### 2.2 Time Metadata

- Tables that represent mutable domain records should include `created_at timestamptz not null default timezone('utc', now())`.
- Mutable domain tables should also include `updated_at timestamptz not null default timezone('utc', now())`.
- A shared trigger function may manage `updated_at` automatically when the trigger packet is introduced.

### 2.3 Tenant Scope

- Tenant-aware domain tables should include `organization_id`.
- Workspace-scoped domain tables should include both `organization_id` and `workspace_id`.
- `workspace_id` should never imply organization membership silently; the workspace must belong to the referenced organization.

### 2.4 Ownership and Attribution

- Tables that have a human owner or creator should use explicit foreign keys such as `created_by_user_id`, `owner_user_id`, or equivalent names that make the relationship obvious.
- Avoid generic actor columns when a more specific name exists.

### 2.5 Canonical Source References

- Derived or mirrored tables should store the canonical source record information explicitly.
- When a table represents memory, AI output, or synchronization state, it should reference the canonical source table and canonical source ID where practical.
- External systems such as Qdrant must never become the truth owner.

---

## 3. Standard Column Patterns

### 3.1 Tenant-Scoped Domain Table

Typical column pattern:

- `id`
- `organization_id`
- `workspace_id`
- domain-specific columns
- `created_at`
- `updated_at`

### 3.2 User-Attributed Domain Table

When authorship matters, add:

- `created_by_user_id`
- optionally `updated_by_user_id`

### 3.3 Derived Record Table

When a record is produced from another canonical record, add:

- `source_table`
- `source_record_id`
- provider or model metadata when applicable

---

## 4. Naming Rules

- Use plural snake_case table names.
- Use singular snake_case column names.
- Enum names should reflect the business concept, such as `idea_status` or `risk_level`.
- Join tables should use clear plural names such as `workspace_memberships`.

---

## 5. Constraint Rules

- Add unique constraints where the business identity would otherwise drift.
- Prefer explicit named constraints for multi-column uniqueness.
- Use `on delete cascade` where child records should not survive the parent boundary.
- Avoid silent orphan records across organization or workspace boundaries.

---

## 6. Future Application

These rules should be applied in later packets for:

- founder profile and planning tables,
- business idea tables,
- assumptions, evidence, and experiments,
- decisions, reviews, and risks,
- scorecards, tasks, tags, and attachments,
- memory and embedding tables,
- and Qdrant sync tables.

---

## 7. Relationship to ADR-001

These conventions support ADR-001 by ensuring that:

- PostgreSQL remains the canonical source of truth,
- derived records are identifiable as derived,
- tenant scope is explicit,
- and future retrieval or AI layers can reference canonical records consistently.
