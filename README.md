# Founder Decision OS

Founder Decision OS is a foundation repository for a founder planning, business ideation, and AI-assisted memory system.

The canonical architecture for this repository is:

- PostgreSQL or Supabase as the canonical source of truth
- pgvector as the built-in semantic memory layer
- optional Qdrant as a retrieval accelerator
- Supabase Storage for raw evidence files
- AI workflows as derived interpretation layers, not truth owners

## Current Scope

This repository is being built incrementally through GitHub issues and pull requests.

Current completed foundation work in the repository includes:

- GitHub source-of-truth setup and issue automation
- product charter
- Foundation MVP definition and feature matrix
- ADR-001 for the hybrid memory architecture
- productization path and roadmap

Repository, environment, database, and runtime scaffolding are being added in subsequent work packets.

## Repository Workflow

Implementation work is tracked in GitHub issues and reviewable pull requests.

The issue automation script lives at:

```bash
python3 scripts/github/create_founder_decision_os_issues.py --repo OWNER/REPO
python3 scripts/github/create_founder_decision_os_issues.py --repo OWNER/REPO --execute
```

The script is rerunnable and uses `.github/founder-decision-os-issue-state.json` to avoid duplicate setup work.

## Current Repository Layout

```text
.
├── .github/
├── apps/
├── docs/
├── packages/
├── prompts/
├── schemas/
├── scripts/
├── supabase/
└── tests/
```

## Documentation

- [Product Charter](docs/product/product-charter.md)
- [MVP Definition](docs/product/mvp-definition.md)
- [Feature Matrix](docs/product/feature-matrix.md)
- [ADR-001 Hybrid Memory Architecture](docs/architecture/ADR-001-hybrid-memory-architecture.md)
- [Productization Path](docs/architecture/productization-path.md)
- [Roadmap](docs/product/roadmap.md)
- [Codex Handoff](docs/project/codex-handoff.md)

## Status

The repository does not yet include the runnable local environment, Docker setup, Makefile, or database migrations.

Those will be added in the E1, E2, and E3 work packets rather than being implied prematurely here.
