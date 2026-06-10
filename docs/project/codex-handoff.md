# Codex Handoff — Founder Decision OS Foundation MVP Repository Build

## 0. Mission

You are Codex acting as the implementation agent for the **Founder Decision OS / Business Ideation OS / AI Cofounder Memory System**.

Your job is to build a complete, runnable, testable, productizable **Foundation MVP repository** using GitHub as the source of truth for issues, commits, branches, pull requests, and implementation history.

This is not a planning-only task.

Build the repository incrementally through reviewable GitHub Issues and pull requests.

The system architecture is canonical:

- **PostgreSQL/Supabase is the canonical brain and system of record.**
- **pgvector is the built-in semantic memory layer.**
- **Qdrant is an optional external retrieval accelerator.**
- **Supabase Storage stores raw evidence files.**
- **AI workflows interpret, summarize, and recommend, but never become the source of truth.**

The product begins as a personal founder planning system but must be designed from the start as a future SaaS/productized platform.

## 1. Source-of-Truth Rules

GitHub is the source of truth for this build.

Use GitHub for:

- Epics
- Work packets
- Tasks
- Branches
- Commits
- Pull requests
- Review notes
- Verification logs
- Known limitations
- Release status

Do not track canonical implementation status only in chat.

Every implementation slice must map to a GitHub Issue.

Every meaningful code/documentation change must be made on a branch and submitted as a PR.

Every PR must reference the issue it resolves.

Every PR must include:

- Summary
- Files changed
- Verification performed
- Test output or honest non-execution reason
- Known limitations
- Follow-up issues if needed

## 2. Important Uploaded Script

A GitHub Issues automation script already exists:

```text
create_founder_decision_os_issues.py
```

Use this script to create:

- Labels
- Milestones
- Epic issues
- Work-packet issues
- Task checklists
- Issue hierarchy references
- State file for reruns

Expected usage:

```bash
python3 create_founder_decision_os_issues.py --repo OWNER/REPO
python3 create_founder_decision_os_issues.py --repo OWNER/REPO --execute
```

If this script has not yet been committed to the repository, add it under:

```text
scripts/github/create_founder_decision_os_issues.py
```

If the GitHub repository does not yet exist, stop and ask for the repo URL or create local files only if explicitly instructed.

## 3. Non-Negotiable Build Principles

### 3.1 Complete Files Only

Do not create placeholder-heavy files.

Forbidden placeholder patterns:

- TODO
- FIXME
- implement later
- omitted for brevity
- truncated
- repeat this pattern
- similar pattern
- etc.
- TBD
- fill this in
- your code here

A file may explicitly document “future work” only when the file is intentionally a scaffold for an optional module and the current behavior is safe, working, and documented.

### 3.2 Test What Can Be Tested

Do not claim a command was tested unless it was actually executed.

Use these verification labels honestly:

- `TESTED`: command was actually run and passed.
- `FAILED_THEN_FIXED`: command failed, files were changed, and command later passed.
- `BLOCKED`: command could not be run due to missing tool, permissions, unavailable service, or environment limitation.
- `NOT_EXECUTED`: command was not run.

### 3.3 PostgreSQL Owns Truth

Never make pgvector or Qdrant the canonical data source.

- Canonical records live in PostgreSQL.
- pgvector indexes retrievable semantic memory.
- Qdrant mirrors retrievable memory when enabled.
- Qdrant payloads must reference canonical PostgreSQL IDs.
- AI responses must cite or reference canonical records where practical.

### 3.4 Optional Means Optional

The following feature flags must exist:

```env
ENABLE_QDRANT=false
ENABLE_AI_WORKER=false
ENABLE_REPORT_GENERATION=false
ENABLE_WEB_APP=false
ENABLE_SUPABASE_STORAGE=true
ENABLE_PGVECTOR=true
```

When disabled, optional modules must not break:

- Database startup
- Migrations
- Seed data
- Verification scripts
- Core tests

### 3.5 Prefer Small PRs

Do not build the entire repo in one PR.

Use one work packet per PR unless a work packet is too large; then split it into smaller PRs and document the split.

## 4. Recommended Execution Sequence

Execute in this order.

### Phase 0 — GitHub Project Setup

Goal: make GitHub the source of truth.

1. Confirm repository.
2. Add the issue automation script if not already present.
3. Run the script in dry-run mode.
4. Run the script in execute mode if repo access is available.
5. Commit the issue automation script.
6. Open PR for issue automation script if repo is not empty.

Acceptance criteria:

- Labels exist.
- Milestones exist.
- Epic issues exist.
- Work-packet issues exist.
- Work packets are linked from epics.
- State file is saved.
- Script can be rerun without duplicate issues.

### Phase 1 — Repository & Local Development Foundation

Related epics:

- E0
- E1

Goals:

- Establish product/architecture docs.
- Create root repository scaffold.
- Add local development commands.
- Add Docker and environment files.
- Add feature flags.

Primary files:

```text
README.md
LICENSE
.gitignore
.editorconfig
.env.example
.env.local.example
docker-compose.yml
docker-compose.qdrant.yml
Makefile
package.json
tsconfig.json
docs/product/product-charter.md
docs/product/mvp-definition.md
docs/product/feature-matrix.md
docs/architecture/ADR-001-hybrid-memory-architecture.md
docs/architecture/productization-path.md
docs/product/roadmap.md
```

Acceptance criteria:

- Repo structure matches the planned inventory.
- `docker-compose.yml` starts PostgreSQL.
- Qdrant is isolated in `docker-compose.qdrant.yml`.
- `.env.example` documents all required variables.
- Makefile targets do not reference missing scripts.
- README setup commands match actual files.
- ADR-001 clearly records the canonical hybrid architecture.

### Phase 2 — Canonical PostgreSQL/Supabase Schema

Related epics:

- E2
- E3

Goals:

- Build the source-of-truth database schema.
- Add extensions and enums.
- Add identity and tenancy.
- Add founder, ideation, evidence, experiment, decision, scorecard, risk, task, tag, and attachment models.

Primary migration files:

```text
supabase/config.toml
supabase/migrations/001_extensions_and_enums.sql
supabase/migrations/002_identity_and_tenancy.sql
supabase/migrations/003_founder_core.sql
supabase/migrations/004_business_ideation_core.sql
supabase/migrations/005_assumptions_evidence_experiments.sql
supabase/migrations/006_decisions_reviews_risks.sql
supabase/migrations/007_scorecards_tasks_tags.sql
```

Acceptance criteria:

- All required tables exist.
- All required enum/status values exist.
- Foreign keys are valid.
- Migration order is valid.
- Core tables include organization/workspace fields where appropriate.
- Core tables include created/updated metadata.
- Seed data can reference schema without mismatch.
- No documentation claims a table/column that does not exist.

### Phase 3 — AI Summaries, Reports, Memory, and Optional Qdrant

Related epics:

- E4
- E5

Goals:

- Add AI prompt/summary/report schema.
- Add pgvector memory items and embeddings.
- Add optional Qdrant sync queue.
- Add retrieval events.
- Add embedding and Qdrant scripts with safe no-op behavior.

Primary files:

```text
supabase/migrations/008_ai_prompts_summaries_reports.sql
supabase/migrations/009_memory_items_pgvector.sql
supabase/migrations/010_qdrant_sync_tables.sql
scripts/embeddings/README.md
scripts/embeddings/embed-memory-items.ts
scripts/embeddings/reembed-memory-items.ts
scripts/embeddings/verify-embeddings.ts
scripts/qdrant/README.md
scripts/qdrant/sync-memory-items.ts
scripts/qdrant/verify-qdrant.ts
scripts/qdrant/clear-qdrant-collection.ts
apps/worker/src/qdrant-sync-worker.ts
```

Acceptance criteria:

- pgvector extension is enabled or gracefully documented if unavailable.
- `memory_items` exists.
- `memory_embeddings` exists.
- Memory records reference canonical source table/source ID.
- Embeddings include model/provider/dimension metadata.
- Qdrant sync queue exists.
- Qdrant scripts skip safely when `ENABLE_QDRANT=false`.
- Qdrant payload design references PostgreSQL canonical IDs.
- Core system works without Qdrant.

### Phase 4 — Storage, Security, RLS, Indexes, Views, Triggers

Related epics:

- E10

Goals:

- Add storage buckets/policies.
- Add RLS.
- Add indexes.
- Add dashboard/review/memory views.
- Add updated_at triggers.
- Add audit event scaffolding.

Primary files:

```text
supabase/migrations/011_storage_buckets_and_policies.sql
supabase/migrations/012_rls_policies.sql
supabase/migrations/013_indexes.sql
supabase/migrations/014_views.sql
supabase/migrations/015_functions_and_triggers.sql
```

Acceptance criteria:

- RLS is enabled on core tenant-scoped tables.
- Policies enforce organization/workspace isolation where practical.
- Indexes support FK joins, status filters, review dates, search, and queues.
- Views compile.
- Views match the actual schema.
- Triggers update `updated_at`.
- Audit event pattern exists and does not break seed data.
- Storage policies are safe and documented.

### Phase 5 — Seed Data, Verification, and Tests

Related epics:

- E6

Goals:

- Add seed data.
- Add SQL verification.
- Add SQL tests.
- Add smoke tests.
- Add shell scripts.

Primary files:

```text
supabase/seed.sql
scripts/verify.sql
scripts/verify.sh
scripts/smoke-test.sh
scripts/migrate.sh
scripts/seed.sh
scripts/reset-db.sh
supabase/tests/001_schema_smoke_test.sql
supabase/tests/002_seed_data_test.sql
supabase/tests/003_relationship_test.sql
supabase/tests/004_views_test.sql
supabase/tests/005_memory_test.sql
supabase/tests/006_rls_test.sql
supabase/tests/007_qdrant_sync_queue_test.sql
tests/smoke/db-smoke.test.ts
tests/smoke/memory-smoke.test.ts
tests/smoke/qdrant-smoke.test.ts
```

Required seed records:

- D-001
- ADR-001
- V-001 through V-005
- A-001
- BI-001
- Default organization
- Default workspace
- Default user
- At least one memory item

Acceptance criteria:

- Migrations apply.
- Seed data inserts.
- Verification SQL passes.
- SQL tests pass or failures are fixed.
- Smoke tests run or are honestly marked.
- Qdrant tests skip when Qdrant is disabled.
- Verification output is copied into PR.

### Phase 6 — Documentation and Prompt Library

Related epics:

- E7
- E8

Goals:

- Create product docs.
- Create architecture docs.
- Create data model docs.
- Create operating process docs.
- Create troubleshooting docs.
- Create reusable prompt library.

Primary folders:

```text
docs/
prompts/
packages/ai/
```

Acceptance criteria:

- Docs match actual schema.
- Prompt files are complete and reusable.
- Prompt library reinforces source-of-truth rules.
- Troubleshooting docs cover database, migration, pgvector, Qdrant, and Supabase errors.
- Docs contain no broken local file references.
- Docs explain how to use the system as a founder decision ledger.

### Phase 7 — App, Worker, Shared Packages, Schemas, CI

Related epics:

- E9
- E11

Goals:

- Add productizable scaffold without overbuilding UI.
- Add worker scaffold.
- Add DB/AI/shared packages.
- Add JSON schemas and fixtures.
- Add CI workflows.
- Add export/backup scripts.

Primary files/folders:

```text
apps/web/
apps/worker/
packages/db/
packages/ai/
packages/shared/
schemas/
tests/fixtures/
.github/workflows/
scripts/export-schema.sh
scripts/export-data.sh
scripts/backup-db.sh
scripts/restore-db.sh
scripts/generate-types.sh
scripts/lint-sql.sh
```

Acceptance criteria:

- Web app scaffold does not pretend to be a complete UI.
- Worker scaffold has safe no-op behavior when disabled.
- Shared enums align with SQL enums.
- JSON schemas match fixture files.
- CI references real commands/files only.
- Export/backup scripts include safety checks.
- TypeScript compiles or is honestly marked if not executed.

### Phase 8 — Final Integration, Audit, and Release

Related epics:

- E12

Goals:

- Run full verification.
- Fix defects.
- Produce final verification report.
- Prepare release artifact.

Required commands, when environment allows:

```bash
make db-up
make migrate
make seed
make verify
make test
```

Optional Qdrant command:

```bash
make qdrant-up
```

Acceptance criteria:

- Full repo file inventory exists.
- No forbidden placeholders remain.
- Migrations apply in order.
- Seed data inserts.
- Views compile.
- Verification SQL passes.
- Tests pass or non-execution is honestly documented.
- README commands match actual scripts.
- Optional modules are feature-flagged.
- Final verification report exists.
- Final status is one of:
  - COMPLETE_AND_TESTED
  - COMPLETE_BUT_NOT_EXECUTED
  - PARTIALLY_COMPLETE
  - BLOCKED

## 5. Branching and PR Rules

Use branch names like:

```text
wp-e0-001-product-charter
wp-e1-003-docker-local-services
wp-e2-002-extensions-enums
wp-e3-004-decisions-reviews-risks
```

Commit format:

```text
WP-E2-002: add extensions and enum migration
```

PR title format:

```text
WP-E2-002 — Create Extensions and Enums Migration
```

Each PR body must include:

```markdown
## Summary

## Related Issue

Closes #ISSUE_NUMBER

## Files Changed

## Verification

Commands run:

```bash
...
```

Results:

- TESTED / FAILED_THEN_FIXED / BLOCKED / NOT_EXECUTED

## Known Limitations

## Follow-Up Issues
```

Do not merge a PR if:

- It introduces references to missing files.
- It breaks existing verification.
- It adds undocumented environment variables.
- It changes architecture without ADR update.
- It makes Qdrant required for core functionality.
- It makes AI output canonical truth.

## 6. Acceptance Criteria by Layer

### Product Layer

- Product charter exists.
- MVP definition exists.
- Feature matrix exists.
- Roadmap exists.
- Productization path exists.
- User personas and use cases exist.

### Architecture Layer

- ADR-001 exists.
- Source-of-truth rules exist.
- Data flow exists.
- Trust boundaries exist.
- AI memory design exists.
- Qdrant sync design exists.

### Database Layer

- Required migrations exist.
- Required tables exist.
- Required enums exist.
- Foreign keys work.
- Indexes exist.
- Views compile.
- Triggers work.
- Seed data inserts.

### Memory Layer

- pgvector is supported.
- Memory items exist.
- Memory embeddings exist.
- Embedding metadata is recorded.
- Memory items reference canonical records.
- Retrieval queries filter by tenant/workspace.

### Qdrant Layer

- Qdrant is optional.
- Sync queue exists.
- Scripts skip safely when disabled.
- Qdrant payloads reference PostgreSQL IDs.
- Core system works without Qdrant.

### Security Layer

- RLS policies exist.
- Organization/workspace isolation is modeled.
- Storage buckets/policies exist.
- Audit events exist or are scaffolded.
- Trust boundaries are documented.

### AI Layer

- Prompt library exists.
- AI outputs are stored as records.
- AI workflows require source references.
- Citation policy exists.
- Retrieval policy exists.
- Memory policy exists.

### Developer Experience Layer

- Makefile exists.
- Scripts exist.
- README commands work or are honestly marked.
- Docker services start or failures are documented.
- CI references real files.
- Backup/export scripts exist.

## 7. Quality Gates

Before opening a PR:

1. Run the relevant commands.
2. Confirm no broken references.
3. Confirm no forbidden placeholders.
4. Confirm docs match files changed.
5. Confirm optional modules are feature-flagged.
6. Confirm any unexecuted tests are honestly marked.

Before merging a milestone:

1. Run full verification.
2. Fix migration drift.
3. Fix docs/schema drift.
4. Update issue checklists.
5. Update release notes or verification report.
6. Confirm GitHub issues reflect actual progress.

## 8. First Codex Task

Start with **WP-000 — Prepare GitHub Source of Truth**.

If the repository exists and GitHub CLI is available:

1. Add `create_founder_decision_os_issues.py` to `scripts/github/create_founder_decision_os_issues.py`.
2. Run:

```bash
python3 scripts/github/create_founder_decision_os_issues.py --repo OWNER/REPO
```

3. If dry run looks correct, run:

```bash
python3 scripts/github/create_founder_decision_os_issues.py --repo OWNER/REPO --execute
```

4. Commit the script and state file if appropriate.
5. Open a PR titled:

```text
WP-000 — Prepare GitHub Source of Truth
```

If the repository does not exist or repo access is unavailable:

1. Create a local branch.
2. Add the issue automation script.
3. Add this handoff file as `docs/project/codex-handoff.md`.
4. Stop and report what is blocked.

Acceptance criteria for WP-000:

- Issue automation script exists in repo.
- Dry-run command is documented.
- Execute command is documented.
- GitHub labels/milestones/issues are created if access exists.
- State file is created if execution occurs.
- No duplicate issues are created on rerun.
- PR explains whether execution was TESTED, BLOCKED, or NOT_EXECUTED.

## 9. Second Codex Task

After WP-000, execute **WP-E0-001 — Define Product Charter**.

Create:

```text
docs/product/product-charter.md
```

Then execute WP-E0-002, WP-E0-003, and WP-E0-004.

Do not start database migrations until E0 and E1 are complete enough to provide repository structure, environment files, and command conventions.

## 10. Communication Back to User

After each PR, report:

- PR title
- Issue closed
- Files changed
- Commands run
- Test status
- Failures
- Fixes
- Remaining risks
- Recommended next work packet

The user will continue using ChatGPT to review:

- errors
- architecture
- schema quality
- prompt quality
- issue sequencing
- next-stage decisions

Do not hide uncertainty.

Do not claim completion beyond what has been verified.
