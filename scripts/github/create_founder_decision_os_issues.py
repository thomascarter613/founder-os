#!/usr/bin/env python3
"""
Automate GitHub source-of-truth issue setup for the Founder Decision OS MVP.

Canonical repository path:
  scripts/github/create_founder_decision_os_issues.py

Usage:
  python3 scripts/github/create_founder_decision_os_issues.py --repo OWNER/REPO
  python3 scripts/github/create_founder_decision_os_issues.py --repo OWNER/REPO --execute
  python3 scripts/github/create_founder_decision_os_issues.py --repo OWNER/REPO --execute --only setup
  python3 scripts/github/create_founder_decision_os_issues.py --repo OWNER/REPO --execute --only issues
  python3 scripts/github/create_founder_decision_os_issues.py --repo OWNER/REPO --execute --state .github/fdos-issue-state.json
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any


LABELS: list[dict[str, str]] = [
    {"name": "type: epic", "color": "5319E7", "description": "Large product outcome containing multiple work packets"},
    {"name": "type: work-packet", "color": "1D76DB", "description": "Reviewable implementation slice, usually one PR"},
    {"name": "type: task", "color": "C5DEF5", "description": "Small implementation task"},
    {"name": "area: architecture", "color": "0052CC", "description": "Architecture and system design"},
    {"name": "area: database", "color": "0E8A16", "description": "PostgreSQL schema, migrations, indexes, and views"},
    {"name": "area: supabase", "color": "3ECF8E", "description": "Supabase config, storage, RLS, auth assumptions"},
    {"name": "area: pgvector", "color": "7057FF", "description": "pgvector semantic memory layer"},
    {"name": "area: qdrant", "color": "B60205", "description": "Optional Qdrant retrieval accelerator"},
    {"name": "area: docs", "color": "0075CA", "description": "Documentation"},
    {"name": "area: prompts", "color": "FBCA04", "description": "AI prompt and workflow library"},
    {"name": "area: scripts", "color": "006B75", "description": "Automation, backup, export, verification scripts"},
    {"name": "area: testing", "color": "D93F0B", "description": "Tests and verification"},
    {"name": "area: worker", "color": "6F42C1", "description": "Background worker scaffolding"},
    {"name": "area: web", "color": "2188FF", "description": "Web app scaffolding"},
    {"name": "area: security", "color": "B60205", "description": "RLS, auditability, storage policies, trust boundaries"},
    {"name": "area: ci", "color": "5319E7", "description": "CI/CD and GitHub Actions"},
    {"name": "priority: critical", "color": "B60205", "description": "Critical path"},
    {"name": "priority: high", "color": "D93F0B", "description": "High priority"},
    {"name": "priority: medium", "color": "FBCA04", "description": "Medium priority"},
    {"name": "priority: low", "color": "0E8A16", "description": "Low priority"},
    {"name": "status: ready", "color": "C2E0C6", "description": "Ready to begin"},
    {"name": "status: active", "color": "1D76DB", "description": "Currently active"},
    {"name": "status: blocked", "color": "B60205", "description": "Blocked"},
    {"name": "status: review", "color": "FBCA04", "description": "Ready for review"},
    {"name": "status: done", "color": "0E8A16", "description": "Done"},
]

MILESTONES: list[dict[str, str]] = [
    {"title": "M0 — Planning Complete", "description": "Product charter, architecture, MVP scope, and work breakdown accepted."},
    {"title": "M1 — Runnable Database Foundation", "description": "Repository, local dev, Supabase/PostgreSQL schema, and core data model are runnable."},
    {"title": "M2 — Memory Foundation", "description": "pgvector memory layer exists and Qdrant optional retrieval scaffolding is present."},
    {"title": "M3 — Verification Foundation", "description": "Seed data, verification scripts, SQL tests, RLS, storage, views, and indexes exist."},
    {"title": "M4 — Productization Foundation", "description": "Prompt library, documentation, app/worker scaffolding, scripts, CI, schemas, and packages exist."},
    {"title": "M5 — Foundation MVP Release", "description": "Final verification, fixes, release notes, and package are complete."},
]


@dataclass(frozen=True)
class WorkPacket:
    key: str
    title: str
    objective: str
    labels: list[str]
    priority: str
    tasks: list[str]


@dataclass(frozen=True)
class Epic:
    key: str
    title: str
    objective: str
    deliverables: list[str]
    labels: list[str]
    milestone: str
    priority: str
    work_packets: list[WorkPacket]


EPICS: list[Epic] = [
    Epic(
        key="E0",
        title="Product & Architecture Foundation",
        objective="Establish the canonical product definition, MVP scope, architecture decisions, and non-negotiable design principles.",
        deliverables=["Product charter", "MVP definition", "Feature matrix", "ADR-001", "Source-of-truth rules", "Productization path"],
        labels=["area: architecture", "area: docs"],
        milestone="M0 — Planning Complete",
        priority="priority: critical",
        work_packets=[
            WorkPacket("WP-E0-001", "Define Product Charter", "Define the product identity, user, promise, and operating boundaries.", ["area: architecture", "area: docs"], "priority: critical", ["Define product identity and core promise.", "Define primary founder user and use case.", "Define records the system must preserve.", "Define non-goals and trust boundaries.", "Create docs/product/product-charter.md."]),
            WorkPacket("WP-E0-002", "Define Foundation MVP Scope", "Define the MVP as a productizable foundation rather than a throwaway prototype.", ["area: architecture", "area: docs"], "priority: critical", ["Define must-have, should-have, and could-have scope.", "Define feature-flag rules.", "Define completion criteria.", "Create docs/product/mvp-definition.md.", "Create docs/product/feature-matrix.md."]),
            WorkPacket("WP-E0-003", "Record Canonical Architecture Decision", "Lock the hybrid memory architecture as the canonical system decision.", ["area: architecture", "area: pgvector", "area: qdrant", "area: docs"], "priority: critical", ["Record ADR-001.", "State PostgreSQL/Supabase is canonical truth.", "State pgvector is built-in memory.", "State Qdrant is optional.", "State AI interprets but does not own truth."]),
            WorkPacket("WP-E0-004", "Define Productization Path", "Define how the personal system evolves into an internal tool and future SaaS product.", ["area: architecture", "area: docs"], "priority: high", ["Define personal-use phase.", "Define internal tool phase.", "Define multi-tenant SaaS path.", "Define AI memory system path.", "Create docs/architecture/productization-path.md and docs/product/roadmap.md."]),
        ],
    ),
    Epic(
        key="E1",
        title="Repository & Local Development Foundation",
        objective="Create the complete repository skeleton and local development environment.",
        deliverables=["Repository skeleton", "Root configs", "Docker Compose", "Makefile", "Environment files", "Package configuration"],
        labels=["area: scripts", "area: database"],
        milestone="M1 — Runnable Database Foundation",
        priority="priority: critical",
        work_packets=[
            WorkPacket("WP-E1-001", "Create Repository Skeleton", "Create the required folder tree and baseline repository files.", ["area: docs", "area: scripts"], "priority: critical", ["Create the root repository scaffold.", "Add README, LICENSE, .gitignore, and .editorconfig.", "Create intentional empty directories with .gitkeep.", "Verify the tree matches the required inventory."]),
            WorkPacket("WP-E1-002", "Add Environment Configuration", "Add environment examples and feature flags for optional modules.", ["area: scripts"], "priority: critical", ["Create .env.example.", "Create .env.local.example.", "Document required variables.", "Add optional module feature flags."]),
            WorkPacket("WP-E1-003", "Add Docker & Local Services", "Add local Docker services for PostgreSQL and optional Qdrant.", ["area: database", "area: qdrant", "area: scripts"], "priority: critical", ["Create docker-compose.yml.", "Create docker-compose.qdrant.yml.", "Ensure PostgreSQL boots without Qdrant.", "Document service commands."]),
            WorkPacket("WP-E1-004", "Add Root Package & TypeScript Config", "Add root package metadata and TypeScript configuration.", ["area: scripts"], "priority: high", ["Create package.json.", "Create tsconfig.json.", "Align scripts with actual files."]),
            WorkPacket("WP-E1-005", "Add Makefile", "Add a Makefile that maps to real repository commands.", ["area: scripts"], "priority: high", ["Create Makefile.", "Add db-up, migrate, seed, verify, test, and qdrant-up targets.", "Ensure targets do not reference missing scripts."]),
        ],
    ),
    Epic(
        key="E2",
        title="Supabase/PostgreSQL Core Schema",
        objective="Create the Supabase project config and core schema conventions.",
        deliverables=["Supabase config", "Extensions and enums", "Identity and tenancy", "Shared table conventions"],
        labels=["area: database", "area: supabase"],
        milestone="M1 — Runnable Database Foundation",
        priority="priority: critical",
        work_packets=[
            WorkPacket("WP-E2-001", "Configure Supabase Project", "Create Supabase project configuration and migration directory structure.", ["area: database", "area: supabase"], "priority: high", ["Create supabase/config.toml.", "Establish the migration directory structure.", "Document local Supabase assumptions."]),
            WorkPacket("WP-E2-002", "Create Extensions and Enums Migration", "Create the extensions and enums migration.", ["area: database", "area: supabase", "area: pgvector"], "priority: critical", ["Enable required database extensions.", "Define shared status enums.", "Document pgvector availability requirements."]),
            WorkPacket("WP-E2-003", "Create Identity and Tenancy Schema", "Create identity, organization, and workspace schema.", ["area: database", "area: supabase"], "priority: critical", ["Create tenant-aware identity tables.", "Add organization and workspace boundaries.", "Define foreign-key relationships."]),
            WorkPacket("WP-E2-004", "Add Shared Table Conventions", "Add shared metadata, timestamps, and source-of-truth conventions.", ["area: database", "area: docs"], "priority: high", ["Define created_at and updated_at conventions.", "Define canonical ID and tenant scoping patterns.", "Document schema conventions."]),
        ],
    ),
    Epic(
        key="E3",
        title="Founder Decision Data Model",
        objective="Create the canonical founder planning, evidence, and decision schema.",
        deliverables=["Founder tables", "Ideation tables", "Evidence tables", "Decision tables", "Scorecard and tagging tables"],
        labels=["area: database", "area: supabase"],
        milestone="M1 — Runnable Database Foundation",
        priority="priority: critical",
        work_packets=[
            WorkPacket("WP-E3-001", "Founder Core Tables", "Create founder profile and operating context tables.", ["area: database", "area: supabase"], "priority: critical", ["Create founder core tables.", "Add tenant scope and metadata.", "Link founder entities to workspace context."]),
            WorkPacket("WP-E3-002", "Business Ideation Core Tables", "Create business idea and opportunity modeling tables.", ["area: database", "area: supabase"], "priority: critical", ["Create opportunity and idea tables.", "Capture themes, markets, and channels.", "Link ideas to founder context."]),
            WorkPacket("WP-E3-003", "Assumptions, Evidence, and Experiments", "Create evidence-backed learning tables.", ["area: database", "area: supabase"], "priority: critical", ["Create assumptions tables.", "Create evidence and experiment tables.", "Link evidence to canonical records."]),
            WorkPacket("WP-E3-004", "Decisions, Reviews, Risks, and Pivots", "Create decision ledger tables.", ["area: database", "area: supabase"], "priority: critical", ["Create decisions tables.", "Create review cadence tables.", "Create risk and pivot tracking tables."]),
            WorkPacket("WP-E3-005", "Scorecards, Tasks, Tags, and Linking", "Create scoring and execution support tables.", ["area: database", "area: supabase"], "priority: high", ["Create scorecards.", "Create tasks and tags.", "Create cross-record linking tables."]),
        ],
    ),
    Epic(
        key="E4",
        title="pgvector Semantic Memory Layer",
        objective="Create the built-in semantic memory layer on top of PostgreSQL.", deliverables=["Memory schema", "Memory indexes", "Embedding scripts", "Verification scripts"],
        labels=["area: database", "area: pgvector"],
        milestone="M2 — Memory Foundation",
        priority="priority: critical",
        work_packets=[
            WorkPacket("WP-E4-001", "Create Memory Schema", "Create canonical memory items and embeddings tables.", ["area: database", "area: pgvector"], "priority: critical", ["Create memory_items.", "Create memory_embeddings.", "Reference canonical source table and source ID.", "Record provider and model metadata."]),
            WorkPacket("WP-E4-002", "Add Memory Indexes and Search", "Add pgvector indexes and retrieval support.", ["area: database", "area: pgvector"], "priority: high", ["Add vector indexes.", "Add tenant-aware retrieval support.", "Add similarity and source filters."]),
            WorkPacket("WP-E4-003", "Add Embedding Scripts", "Add embedding and re-embedding scripts with safe behavior.", ["area: pgvector", "area: scripts"], "priority: medium", ["Create embed-memory-items.ts.", "Create reembed-memory-items.ts.", "Create verify-embeddings.ts.", "Skip safely when dependencies are unavailable."]),
            WorkPacket("WP-E4-004", "Add Memory Tests", "Create tests that validate the pgvector memory layer.", ["area: pgvector", "area: testing"], "priority: high", ["Add SQL memory tests.", "Verify canonical source references.", "Verify retrieval filters remain tenant-aware."]),
        ],
    ),
    Epic(
        key="E5",
        title="Optional Qdrant Retrieval Accelerator",
        objective="Add optional external retrieval acceleration without changing canonical truth ownership.",
        deliverables=["Qdrant sync schema", "Qdrant scripts", "Worker scaffold", "Verification scripts"],
        labels=["area: pgvector", "area: qdrant"],
        milestone="M2 — Memory Foundation",
        priority="priority: high",
        work_packets=[
            WorkPacket("WP-E5-001", "Add Qdrant Sync Tables", "Create optional sync queue tables that reference canonical PostgreSQL records.", ["area: database", "area: qdrant"], "priority: high", ["Create qdrant sync queue tables.", "Reference canonical PostgreSQL IDs.", "Support retry metadata and status tracking."]),
            WorkPacket("WP-E5-002", "Add Optional Qdrant Runtime", "Add feature-flagged runtime wiring that keeps Qdrant optional.", ["area: qdrant", "area: scripts"], "priority: medium", ["Add ENABLE_QDRANT runtime checks.", "Ensure core flows do not require Qdrant.", "Document disabled-mode behavior."]),
            WorkPacket("WP-E5-003", "Add Qdrant Scripts", "Create sync and verification scripts with safe no-op behavior when disabled.", ["area: qdrant", "area: scripts"], "priority: medium", ["Create sync-memory-items.ts.", "Create verify-qdrant.ts.", "Create clear-qdrant-collection.ts.", "Skip safely when ENABLE_QDRANT=false."]),
            WorkPacket("WP-E5-004", "Add Qdrant Worker Scaffold", "Create a worker entrypoint for background sync execution.", ["area: qdrant", "area: worker"], "priority: medium", ["Create qdrant-sync-worker.ts.", "Guard execution behind feature flags.", "Preserve safe no-op behavior when disabled."]),
            WorkPacket("WP-E5-005", "Add Qdrant Tests", "Create tests that verify optional Qdrant behavior.", ["area: qdrant", "area: testing"], "priority: medium", ["Create queue-level tests.", "Verify safe skip behavior when disabled.", "Verify canonical PostgreSQL references in mirrored payloads."]),
        ],
    ),
    Epic(
        key="E6",
        title="Seed Data, Verification & SQL Tests",
        objective="Create seed data, SQL verification, and smoke tests for the MVP foundation.",
        deliverables=["Seed data", "Verification scripts", "SQL tests", "Smoke tests"],
        labels=["area: testing", "area: scripts"],
        milestone="M3 — Verification Foundation",
        priority="priority: critical",
        work_packets=[
            WorkPacket("WP-E6-001", "Create Seed Data", "Create canonical seed data for the founder planning system.", ["area: database", "area: testing"], "priority: critical", ["Create supabase/seed.sql.", "Insert default organization, workspace, and user.", "Insert required seed records and at least one memory item."]),
            WorkPacket("WP-E6-002", "Create Verification SQL", "Create verification queries that confirm schema, seed, and memory expectations.", ["area: database", "area: testing", "area: scripts"], "priority: critical", ["Create verify.sql.", "Cover schema and seed validation.", "Cover memory and optional queue validation."]),
            WorkPacket("WP-E6-003", "Create Supabase SQL Tests", "Create SQL-level schema and behavior tests.", ["area: database", "area: supabase", "area: testing"], "priority: high", ["Create schema smoke test.", "Create seed data test.", "Create relationship and view tests.", "Create memory and Qdrant queue tests."]),
            WorkPacket("WP-E6-004", "Add Smoke Tests", "Create TypeScript smoke tests for core flows.", ["area: testing"], "priority: medium", ["Create db-smoke.test.ts.", "Create memory-smoke.test.ts.", "Create qdrant-smoke.test.ts.", "Skip Qdrant paths safely when disabled."]),
            WorkPacket("WP-E6-005", "Add Verification Scripts", "Add shell wrappers that execute migration, seed, verification, and smoke flows.", ["area: testing", "area: scripts"], "priority: high", ["Create verify.sh.", "Create smoke-test.sh.", "Create migrate.sh, seed.sh, and reset-db.sh.", "Document honest execution status."]),
        ],
    ),
    Epic(
        key="E7",
        title="AI Prompt & Workflow Library",
        objective="Create reusable prompts and workflow rules that reinforce canonical source-of-truth behavior.",
        deliverables=["Prompt library", "Citation policy", "Retrieval policy", "Memory policy"],
        labels=["area: prompts", "area: docs"],
        milestone="M4 — Productization Foundation",
        priority="priority: high",
        work_packets=[
            WorkPacket("WP-E7-001", "Create System Prompt Library", "Create the system-level prompts that define source-of-truth rules and operating boundaries.", ["area: docs", "area: prompts"], "priority: high", ["Define system prompts for truth ownership.", "Define citation requirements.", "Define optional service behavior rules."]),
            WorkPacket("WP-E7-002", "Create Research Prompt Library", "Create prompts for research and evidence synthesis.", ["area: prompts"], "priority: medium", ["Create research prompts.", "Create evidence synthesis prompts.", "Require source references."]),
            WorkPacket("WP-E7-003", "Create Scoring Prompt Library", "Create prompts for scoring ideas and opportunities.", ["area: prompts"], "priority: medium", ["Create scorecard prompts.", "Create opportunity comparison prompts.", "Align outputs with canonical records."]),
            WorkPacket("WP-E7-004", "Create Decision and Assumption Prompt Library", "Create prompts for decisions, reviews, and assumptions.", ["area: prompts"], "priority: medium", ["Create decision prompts.", "Create assumption prompts.", "Create review prompts."]),
            WorkPacket("WP-E7-005", "Create Evidence, Experiment, Review, and Memory Prompts", "Create the remaining operational prompt set for evidence, experiments, reviews, and memory workflows.", ["area: prompts"], "priority: medium", ["Create evidence prompts.", "Create experiment prompts.", "Create memory prompts.", "Require canonical record references where practical."]),
        ],
    ),
    Epic(
        key="E8",
        title="Documentation System",
        objective="Create the product, architecture, data model, operations, and troubleshooting documentation set.",
        deliverables=["Product docs", "Architecture docs", "Data model docs", "Operating docs", "Troubleshooting docs"],
        labels=["area: docs"],
        milestone="M4 — Productization Foundation",
        priority="priority: high",
        work_packets=[
            WorkPacket("WP-E8-001", "Architecture Docs", "Create architecture and trust-boundary documentation.", ["area: architecture", "area: docs"], "priority: high", ["Document architecture overview.", "Document trust boundaries.", "Document system data flow."]),
            WorkPacket("WP-E8-002", "Product Docs", "Create user-facing product and process documentation.", ["area: docs"], "priority: medium", ["Document founder workflow.", "Document decision ledger usage.", "Document product terminology."]),
            WorkPacket("WP-E8-003", "Data Model Docs", "Document the canonical schema and entity relationships.", ["area: database", "area: docs"], "priority: medium", ["Document core tables.", "Document enum values.", "Document canonical relationships."]),
            WorkPacket("WP-E8-004", "Operating System Docs", "Document operating procedures for running the system.", ["area: docs"], "priority: medium", ["Document local dev commands.", "Document migration flow.", "Document verification flow."]),
            WorkPacket("WP-E8-005", "Founder, Reports, and Troubleshooting Docs", "Document founder usage and operational troubleshooting.", ["area: docs"], "priority: medium", ["Document founder decision ledger usage.", "Document reports and exports.", "Document troubleshooting for database, pgvector, Qdrant, and Supabase issues."]),
        ],
    ),
    Epic(
        key="E9",
        title="App, Worker & Package Scaffolding",
        objective="Create productizable application and package scaffolding without overbuilding the UI.",
        deliverables=["DB package", "AI package", "Shared package", "Web scaffold", "Worker scaffold"],
        labels=["area: worker", "area: web"],
        milestone="M4 — Productization Foundation",
        priority="priority: medium",
        work_packets=[
            WorkPacket("WP-E9-001", "Create DB Package", "Create shared database access package scaffolding.", ["area: database"], "priority: medium", ["Create packages/db.", "Add connection and query scaffolding.", "Align package exports with actual code."]),
            WorkPacket("WP-E9-002", "Create AI Package", "Create AI package scaffolding for prompt and workflow code.", ["area: prompts"], "priority: medium", ["Create packages/ai.", "Add reusable AI workflow interfaces.", "Preserve source-of-truth boundaries."]),
            WorkPacket("WP-E9-003", "Create Shared Package", "Create shared package scaffolding for enums and utilities.", ["area: scripts"], "priority: medium", ["Create packages/shared.", "Share enums and constants.", "Align code enums with SQL enums."]),
            WorkPacket("WP-E9-004", "Create Web App Scaffold", "Create a web app scaffold that does not pretend to be a complete UI.", ["area: web"], "priority: medium", ["Create apps/web scaffold.", "Expose safe minimal routes.", "Guard optional behavior behind flags."]),
            WorkPacket("WP-E9-005", "Create Worker App Scaffold", "Create worker app scaffolding with safe no-op behavior when disabled.", ["area: worker"], "priority: medium", ["Create apps/worker scaffold.", "Guard worker startup behind flags.", "Avoid hard dependency on optional services."]),
        ],
    ),
    Epic(
        key="E10",
        title="Security, RLS, Storage & Auditability",
        objective="Add storage policies, row-level security, views, indexes, triggers, and audit scaffolding.",
        deliverables=["Storage buckets", "RLS policies", "Indexes", "Views", "Functions and triggers"],
        labels=["area: supabase", "area: security"],
        milestone="M3 — Verification Foundation",
        priority="priority: critical",
        work_packets=[
            WorkPacket("WP-E10-001", "Add Storage Buckets and Policies", "Create Supabase storage buckets and safe policies.", ["area: supabase", "area: security"], "priority: high", ["Create storage bucket migration.", "Add safe bucket policies.", "Document evidence file handling."]),
            WorkPacket("WP-E10-002", "Add RLS Policies", "Add tenant-aware row-level security policies.", ["area: supabase", "area: testing", "area: security"], "priority: critical", ["Enable RLS on tenant tables.", "Add organization and workspace isolation rules.", "Verify RLS with tests."]),
            WorkPacket("WP-E10-003", "Add Indexes", "Add indexes for joins, filters, review dates, search, and queues.", ["area: database", "area: pgvector", "area: qdrant"], "priority: high", ["Index foreign keys and status filters.", "Index review dates and queue lookups.", "Index search and retrieval paths."]),
            WorkPacket("WP-E10-004", "Add Views", "Create dashboard, review, and memory views.", ["area: database", "area: testing"], "priority: high", ["Create dashboard views.", "Create review views.", "Create memory views that match the schema."]),
            WorkPacket("WP-E10-005", "Add Functions, Triggers, and Audit Events", "Add updated_at triggers and audit scaffolding.", ["area: database", "area: security"], "priority: high", ["Create updated_at trigger functions.", "Apply triggers to core tables.", "Create audit event scaffolding."]),
        ],
    ),
    Epic(
        key="E11",
        title="CI, Scripts, Export/Backup & Developer Tooling",
        objective="Create the supporting scripts, schemas, fixtures, and CI workflow needed for productization.",
        deliverables=["Export scripts", "Type generation", "JSON schemas", "Fixtures", "CI workflows"],
        labels=["area: scripts", "area: ci"],
        milestone="M4 — Productization Foundation",
        priority="priority: high",
        work_packets=[
            WorkPacket("WP-E11-001", "Add Export and Backup Scripts", "Create safe export and backup scripts.", ["area: scripts"], "priority: medium", ["Create export-schema.sh.", "Create export-data.sh.", "Create backup-db.sh and restore-db.sh.", "Add safety checks."]),
            WorkPacket("WP-E11-002", "Add Type Generation and SQL Lint Scripts", "Create type generation and SQL lint entrypoints.", ["area: scripts"], "priority: medium", ["Create generate-types.sh.", "Create lint-sql.sh.", "Align scripts with actual files."]),
            WorkPacket("WP-E11-003", "Add JSON Schemas", "Create JSON schemas for product artifacts.", ["area: database", "area: scripts"], "priority: medium", ["Create schemas directory.", "Add schema files.", "Align schemas with fixtures."]),
            WorkPacket("WP-E11-004", "Add Fixtures", "Create fixture data for testing and validation.", ["area: testing"], "priority: medium", ["Create tests/fixtures.", "Add fixture files.", "Keep fixtures aligned with schemas."]),
            WorkPacket("WP-E11-005", "Add GitHub CI", "Create CI workflows that call real commands.", ["area: testing", "area: ci"], "priority: high", ["Create .github/workflows files.", "Reference real scripts and commands.", "Avoid broken CI references."]),
        ],
    ),
    Epic(
        key="E12",
        title="Final Integration, Testing & Release Package",
        objective="Run final verification, fix defects, and prepare a release artifact for the foundation MVP.",
        deliverables=["Full verification run", "Consistency audit", "Verification report", "Release artifact"],
        labels=["area: testing", "area: scripts"],
        milestone="M5 — Foundation MVP Release",
        priority="priority: critical",
        work_packets=[
            WorkPacket("WP-E12-001", "Run Full Local Verification", "Run the full command set when the environment allows it.", ["area: testing"], "priority: critical", ["Run make db-up.", "Run make migrate.", "Run make seed.", "Run make verify and make test."]),
            WorkPacket("WP-E12-002", "Fix Migration and Seed Errors", "Fix defects uncovered by final verification.", ["area: database", "area: testing"], "priority: critical", ["Fix migration drift.", "Fix seed mismatches.", "Re-run affected verification."]),
            WorkPacket("WP-E12-003", "Run Consistency Audit", "Audit docs, schema, and scripts for drift and broken references.", ["area: docs", "area: testing", "area: scripts"], "priority: high", ["Check schema-doc drift.", "Check broken references.", "Check forbidden placeholders."]),
            WorkPacket("WP-E12-004", "Produce Final Verification Report", "Create the final verification report and release readiness summary.", ["area: docs", "area: testing"], "priority: high", ["Summarize executed commands.", "Record blocked steps honestly.", "State final status."]),
            WorkPacket("WP-E12-005", "Package Release Artifact", "Prepare the release package and handoff artifact.", ["area: docs", "area: scripts"], "priority: medium", ["Prepare release artifact.", "Document known limitations.", "Capture follow-up issues."]),
        ],
    ),
]


def run_command(args: list[str], *, input_text: str | None = None) -> str:
    result = subprocess.run(
        args,
        input=input_text,
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(
            f"Command failed ({result.returncode}): {' '.join(args)}\n"
            f"STDOUT:\n{result.stdout}\nSTDERR:\n{result.stderr}"
        )
    return result.stdout


def load_state(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {"labels": {}, "milestones": {}, "epics": {}, "work_packets": {}}
    return json.loads(path.read_text())


def save_state(path: Path, state: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(state, indent=2, sort_keys=True) + "\n")


def print_action(dry_run: bool, message: str) -> None:
    prefix = "[DRY-RUN]" if dry_run else "[EXECUTE]"
    print(f"{prefix} {message}")


def milestone_map(repo: str) -> dict[str, int]:
    raw = run_command(["gh", "api", f"repos/{repo}/milestones?state=all&per_page=100"])
    items = json.loads(raw)
    return {item["title"]: item["number"] for item in items}


def label_set(repo: str) -> set[str]:
    raw = run_command(["gh", "api", f"repos/{repo}/labels?per_page=100"])
    items = json.loads(raw)
    return {item["name"] for item in items}


def issue_map(repo: str) -> dict[str, dict[str, Any]]:
    raw = run_command(["gh", "issue", "list", "--repo", repo, "--state", "all", "--limit", "200", "--json", "number,title,url"])
    items = json.loads(raw)
    return {item["title"]: item for item in items}


def ensure_labels(repo: str, state: dict[str, Any], dry_run: bool) -> None:
    existing = label_set(repo)
    for label in LABELS:
        name = label["name"]
        if name in existing:
            state["labels"][name] = True
            print_action(dry_run, f"label exists: {name}")
            continue
        print_action(dry_run, f"create label: {name}")
        if not dry_run:
            run_command(
                [
                    "gh",
                    "label",
                    "create",
                    name,
                    "--repo",
                    repo,
                    "--color",
                    label["color"],
                    "--description",
                    label["description"],
                ]
            )
            state["labels"][name] = True


def ensure_milestones(repo: str, state: dict[str, Any], dry_run: bool) -> None:
    existing = milestone_map(repo)
    for milestone in MILESTONES:
        title = milestone["title"]
        if title in existing:
            state["milestones"][title] = existing[title]
            print_action(dry_run, f"milestone exists: {title} -> #{existing[title]}")
            continue
        print_action(dry_run, f"create milestone: {title}")
        if not dry_run:
            run_command(
                [
                    "gh",
                    "api",
                    "-X",
                    "POST",
                    f"repos/{repo}/milestones",
                    "-f",
                    f"title={title}",
                    "-f",
                    f"description={milestone['description']}",
                ]
            )
            state["milestones"] = milestone_map(repo)


def epic_title(epic: Epic) -> str:
    return f"{epic.key} — {epic.title}"


def work_packet_title(work_packet: WorkPacket) -> str:
    return f"{work_packet.key} — {work_packet.title}"


def render_epic_body(epic: Epic, state: dict[str, Any]) -> str:
    lines = [
        "## Objective",
        epic.objective,
        "",
        "## Deliverables",
    ]
    lines.extend(f"- {item}" for item in epic.deliverables)
    lines.extend(["", "## Work Packets"])
    for work_packet in epic.work_packets:
        existing = state["work_packets"].get(work_packet.key)
        if existing:
            lines.append(f"- [ ] #{existing['number']} {work_packet_title(work_packet)}")
        else:
            lines.append(f"- [ ] {work_packet_title(work_packet)}")
    return "\n".join(lines)


def render_work_packet_body(epic: Epic, work_packet: WorkPacket, state: dict[str, Any]) -> str:
    parent = state["epics"].get(epic.key)
    lines = [
        "## Parent Epic",
        f"Part of #{parent['number']} {epic_title(epic)}" if parent else epic_title(epic),
        "",
        "## Objective",
        work_packet.objective,
        "",
        "## Tasks",
    ]
    lines.extend(f"- [ ] {task}" for task in work_packet.tasks)
    lines.extend(
        [
            "",
            "## Acceptance Notes",
            "- Every implementation slice must map to a branch, commit, and review artifact.",
            "- Verification results must be recorded honestly as TESTED, FAILED_THEN_FIXED, BLOCKED, or NOT_EXECUTED.",
            "- Optional modules must remain optional and must not become canonical truth owners.",
        ]
    )
    return "\n".join(lines)


def create_or_update_issue(
    repo: str,
    *,
    title: str,
    body: str,
    labels: list[str],
    milestone: str,
    dry_run: bool,
    existing_by_title: dict[str, dict[str, Any]],
) -> dict[str, Any]:
    if title in existing_by_title:
        issue = existing_by_title[title]
        number = str(issue["number"])
        print_action(dry_run, f"update issue: #{number} {title}")
        if not dry_run:
            run_command(
                [
                    "gh",
                    "issue",
                    "edit",
                    number,
                    "--repo",
                    repo,
                    "--title",
                    title,
                    "--body",
                    body,
                    "--milestone",
                    milestone,
                    "--add-label",
                    ",".join(labels),
                ]
            )
        return issue

    print_action(dry_run, f"create issue: {title}")
    if dry_run:
        return {"number": 0, "title": title, "url": ""}

    output = run_command(
        [
            "gh",
            "issue",
            "create",
            "--repo",
            repo,
            "--title",
            title,
            "--body",
            body,
            "--milestone",
            milestone,
            "--label",
            labels[0],
            *sum([["--label", label] for label in labels[1:]], []),
        ]
    ).strip()
    refreshed = issue_map(repo)
    created = refreshed[title]
    created["url"] = output or created["url"]
    existing_by_title.update(refreshed)
    return created


def ensure_issues(repo: str, state: dict[str, Any], dry_run: bool) -> None:
    existing = issue_map(repo)

    for epic in EPICS:
        title = epic_title(epic)
        epic_issue = create_or_update_issue(
            repo,
            title=title,
            body=render_epic_body(epic, state),
            labels=["type: epic", *epic.labels, epic.priority, "status: ready"],
            milestone=epic.milestone,
            dry_run=dry_run,
            existing_by_title=existing,
        )
        if not dry_run:
            state["epics"][epic.key] = {
                "number": epic_issue["number"],
                "title": title,
                "url": epic_issue["url"],
            }

        for work_packet in epic.work_packets:
            wp_title = work_packet_title(work_packet)
            wp_issue = create_or_update_issue(
                repo,
                title=wp_title,
                body=render_work_packet_body(epic, work_packet, state),
                labels=["type: work-packet", *work_packet.labels, work_packet.priority, "status: ready"],
                milestone=epic.milestone,
                dry_run=dry_run,
                existing_by_title=existing,
            )
            if not dry_run:
                state["work_packets"][work_packet.key] = {
                    "number": wp_issue["number"],
                    "parent_epic": epic.key,
                    "title": wp_title,
                    "url": wp_issue["url"],
                }

        if not dry_run:
            updated_body = render_epic_body(epic, state)
            run_command(
                [
                    "gh",
                    "issue",
                    "edit",
                    str(state["epics"][epic.key]["number"]),
                    "--repo",
                    repo,
                    "--body",
                    updated_body,
                ]
            )


def print_summary(state: dict[str, Any], dry_run: bool) -> None:
    mode = "DRY RUN" if dry_run else "EXECUTED"
    print(f"\nSummary ({mode})")
    print(f"- Labels tracked: {len(state.get('labels', {}))}")
    print(f"- Milestones tracked: {len(state.get('milestones', {}))}")
    print(f"- Epics tracked: {len(state.get('epics', {}))}")
    print(f"- Work packets tracked: {len(state.get('work_packets', {}))}")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Create Founder Decision OS GitHub setup issues.")
    parser.add_argument("--repo", required=True, help="GitHub repository in OWNER/REPO format.")
    parser.add_argument("--execute", action="store_true", help="Actually make changes in GitHub.")
    parser.add_argument("--only", choices=["setup", "issues"], help="Run only setup or only issue creation.")
    parser.add_argument("--state", default=".github/founder-decision-os-issue-state.json", help="State file path.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    state_path = Path(args.state)
    state = load_state(state_path)
    dry_run = not args.execute

    print(f"Repository: {args.repo}")
    print(f"Mode: {'execute' if args.execute else 'dry-run'}")
    print(f"State file: {state_path}")

    try:
        if args.only in (None, "setup"):
            ensure_labels(args.repo, state, dry_run)
            ensure_milestones(args.repo, state, dry_run)
            if args.execute:
                save_state(state_path, state)

        if args.only in (None, "issues"):
            ensure_issues(args.repo, state, dry_run)
            if args.execute:
                save_state(state_path, state)
    except RuntimeError as error:
        print(str(error), file=sys.stderr)
        return 1

    if args.execute:
        save_state(state_path, state)
    print_summary(state, dry_run)
    if args.execute:
        print(f"State saved to: {state_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
