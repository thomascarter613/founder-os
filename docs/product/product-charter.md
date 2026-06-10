# Founder Decision OS Product Charter

## Document Status

**Document:** Product Charter
**Product:** Founder Decision OS
**Alternative Names:** Business Ideation OS, AI Cofounder Memory System, Startup Choice Engine, Venture Decision Ledger, Business Formation Intelligence System
**Work Packet:** WP-E0-001 — Define Product Charter
**Status:** Draft v0.1
**Canonical Architecture:** PostgreSQL/Supabase canonical brain + pgvector semantic memory + optional Qdrant retrieval accelerator
**Primary Audience:** Founder, builder, or entrepreneur deciding what business to start
**Secondary Audience:** Future product team, AI agent, implementation agent, investor, advisor, or customer success operator

---

# 1. Product Summary

Founder Decision OS is a structured founder operating system for documenting, analyzing, validating, and improving the process of deciding what business to start.

It is designed for a founder who knows they want to start a business, but does not yet know which business to start.

The product exists to replace vague ideation, scattered notes, random AI chats, intuition-only decisions, and undocumented pivots with a structured, evidence-based, auditable decision system.

Founder Decision OS records the variables, assumptions, evidence, experiments, scores, risks, trade-offs, reviews, and decisions that shape the creation of a business.

The first version begins as a personal founder planning system. However, it is architected from day one as a productizable platform that may later become a SaaS product, AI founder assistant, business ideation operating system, or AI cofounder memory infrastructure.

---

# 2. Core Product Promise

Founder Decision OS helps a founder answer the question:

> What business should I start, and why?

It does this by creating a traceable system for:

* identifying decision variables,
* documenting founder constraints,
* generating and comparing business ideas,
* extracting assumptions,
* collecting evidence,
* designing validation experiments,
* scoring opportunities,
* recording decisions,
* reviewing prior choices,
* detecting contradictions,
* managing pivots,
* and building an AI-retrievable memory of the founder’s reasoning over time.

The product promise is not merely better note-taking.

The product promise is better founder judgment through structured memory, evidence, validation, and decision discipline.

---

# 3. Problem Statement

Founders often start businesses through an unclear process.

They collect ideas in chats, notebooks, documents, spreadsheets, browser tabs, voice notes, whiteboards, bookmarks, and conversations. Their thinking evolves, but the evolution is rarely preserved. They make decisions based on excitement, anxiety, advice, trend-chasing, or incomplete information. They forget why they rejected an idea. They forget which assumptions were proven false. They confuse opinions with evidence. They build too early. They pivot without preserving the lesson.

This creates several problems:

1. **Decision drift** — the founder changes direction without knowing exactly why.
2. **Lost context** — important reasoning disappears across chats, notes, and documents.
3. **Untracked assumptions** — unproven beliefs quietly drive major decisions.
4. **Weak validation** — ideas are chosen before evidence is collected.
5. **Poor comparability** — business ideas are not evaluated against consistent criteria.
6. **No audit trail** — the founder cannot review how a decision was made.
7. **No memory layer** — AI assistants cannot reliably retrieve and reason from the founder’s actual history.
8. **No operating system** — the founder lacks a repeatable process for going from desire to start a business to evidence-backed business selection.

Founder Decision OS solves this by treating business formation as a structured decision process.

---

# 4. Primary User

The primary user is a founder who wants to start a business but has not yet selected the business.

This user may have:

* limited startup capital,
* limited time,
* competing personal obligations,
* many possible ideas,
* interest in AI leverage,
* uncertainty about markets,
* uncertainty about customers,
* uncertainty about what they can realistically execute,
* a desire to document the process thoroughly,
* and a need to make decisions based on evidence rather than scattered intuition.

The product assumes the founder is not merely brainstorming. The founder is trying to create a real business and wants the decision process to become reviewable, reusable, and eventually productizable.

---

# 5. Secondary Users

Founder Decision OS may eventually serve additional users:

## 5.1 Solo Founder

Uses the system to choose, validate, and launch a business with structured support.

## 5.2 AI Cofounder / AI Agent

Uses the system as memory, retrieval context, and decision history for assisting the founder.

## 5.3 Business Coach or Advisor

Reviews the founder’s assumptions, scorecards, evidence, risks, and decisions.

## 5.4 Startup Studio

Uses the system to compare multiple venture concepts and preserve reasoning across teams.

## 5.5 Productized SaaS Customer

Uses a hosted version to manage their own business ideation and validation process.

## 5.6 Internal AIC Operator

Uses the system as part of a larger Applied Innovation Corp operating platform for AI-enabled business formation, consulting, and venture development.

---

# 6. Product Vision

Founder Decision OS should become the structured memory and decision infrastructure for business formation.

The long-term vision is to create a system that helps founders move from:

> “I want to start a business, but I do not know which one.”

to:

> “I chose this business because the variables, assumptions, evidence, experiments, scorecards, risks, and decisions support it.”

The system should become a durable record of the founder’s journey from uncertainty to opportunity selection, validation, launch, and later growth.

Over time, it may evolve into:

* a founder decision ledger,
* a startup ideation platform,
* a validation operating system,
* a productized service delivery system,
* an AI cofounder memory layer,
* a SaaS product,
* or an internal venture studio tool.

---

# 7. Core Product Principles

## 7.1 PostgreSQL Owns Truth

All canonical records must live in PostgreSQL/Supabase.

The database is the source of truth for:

* variables,
* assumptions,
* business ideas,
* evidence,
* experiments,
* decisions,
* risks,
* scorecards,
* reviews,
* pivots,
* users,
* organizations,
* workspaces,
* permissions,
* and audit events.

## 7.2 AI Interprets, But Does Not Own Truth

AI may summarize, classify, retrieve, compare, score, recommend, and generate drafts.

AI may not become the canonical source of truth.

AI outputs must be stored as records and linked back to the source records they used.

## 7.3 pgvector Enables Built-In Semantic Recall

pgvector is the default semantic memory layer inside PostgreSQL.

It supports retrieval of relevant prior records, notes, summaries, assumptions, decisions, and evidence.

## 7.4 Qdrant Is Optional

Qdrant may be used later as an external retrieval accelerator for large-scale or advanced semantic search.

Qdrant must not be required for the core MVP.

Qdrant must not become the source of truth.

## 7.5 Evidence Beats Excitement

The system should help the founder avoid choosing a business purely because it feels exciting.

A business idea should become stronger only when supported by evidence, validation, founder fit, market reality, and execution feasibility.

## 7.6 Assumptions Must Be Visible

Every business idea depends on assumptions.

The system should make assumptions explicit, testable, reviewable, and linked to decisions.

## 7.7 Decisions Must Be Reviewable

Every important decision should record:

* what was decided,
* when it was decided,
* why it was decided,
* what options were considered,
* what evidence was used,
* what assumptions were accepted,
* what trade-offs were made,
* how reversible the decision is,
* and what would cause the decision to be revisited.

## 7.8 Optional Systems Must Not Break the Core

Optional systems, including Qdrant, workers, report generation, and web UI, must be feature-flagged and disabled by default when appropriate.

The core database, seed data, migrations, verification scripts, and documentation must work without optional services.

---

# 8. What the System Records

Founder Decision OS must record the following categories of information.

## 8.1 Founder Context

* founder profile,
* founder goals,
* founder constraints,
* available capital,
* available time,
* skills,
* energy,
* personal obligations,
* non-negotiables,
* risk tolerance,
* desired business model,
* desired income,
* desired lifestyle,
* and unacceptable business types.

## 8.2 Variables

The system must record variables involved in deciding what business to start, including:

* founder variables,
* capacity variables,
* financial variables,
* skill variables,
* motivation variables,
* market variables,
* customer variables,
* problem variables,
* offer variables,
* business model variables,
* pricing variables,
* sales variables,
* marketing variables,
* competition variables,
* operations variables,
* technology variables,
* AI automation variables,
* legal/risk/compliance variables,
* strategy variables,
* validation variables,
* and decision quality variables.

## 8.3 Business Ideas

The system must record each business idea with:

* name,
* description,
* target customer,
* problem solved,
* proposed offer,
* market,
* business model,
* status,
* score,
* confidence,
* risk level,
* evidence,
* assumptions,
* experiments,
* and decisions.

## 8.4 Markets and Customer Segments

The system must record:

* markets considered,
* customer segments,
* buyer roles,
* customer pains,
* willingness to pay,
* ability to pay,
* reachability,
* buying triggers,
* alternatives,
* and customer language.

## 8.5 Problems and Offers

The system must record:

* problem statements,
* pain intensity,
* current workarounds,
* cost of inaction,
* proposed offers,
* deliverables,
* pricing models,
* risk reversal,
* support model,
* and productization potential.

## 8.6 Assumptions

The system must record:

* assumption statement,
* related idea,
* related market,
* related customer,
* related problem,
* related offer,
* importance,
* confidence,
* risk if false,
* test plan,
* evidence so far,
* validation result,
* and decision impact.

## 8.7 Evidence

The system must record evidence from:

* interviews,
* competitor research,
* reviews,
* forum posts,
* job posts,
* search results,
* customer quotes,
* sales calls,
* outreach replies,
* payments,
* experiment results,
* articles,
* screenshots,
* PDFs,
* transcripts,
* documents,
* and direct observations.

## 8.8 Experiments

The system must record validation experiments with:

* hypothesis,
* method,
* success criteria,
* failure criteria,
* channel,
* audience,
* sample size,
* start date,
* end date,
* result,
* conclusion,
* affected assumptions,
* evidence produced,
* and next action.

## 8.9 Scorecards

The system must record idea scorecards with 1–5 scores for:

* founder fit,
* pain intensity,
* buyer ability to pay,
* buyer willingness to pay,
* reachability,
* speed to revenue,
* low startup cost,
* async potential,
* automation potential,
* repeatability,
* margin potential,
* recurring potential,
* risk level,
* proof potential,
* scalability,
* transferability,
* asset potential,
* exit potential,
* differentiation,
* and personal tolerance.

## 8.10 Decisions

The system must record decisions with:

* decision date,
* decision area,
* decision statement,
* options considered,
* criteria used,
* evidence used,
* assumptions behind the decision,
* trade-offs accepted,
* reversibility,
* risk level,
* confidence level,
* review date,
* change trigger,
* status,
* related records,
* and long-form decision memo.

## 8.11 Risks

The system must record:

* risk name,
* risk category,
* description,
* likelihood,
* impact,
* mitigation,
* owner,
* review date,
* status,
* and related business idea.

## 8.12 Reviews and Pivots

The system must record:

* weekly reviews,
* monthly reviews,
* decision reviews,
* pivot reasons,
* what changed,
* what was learned,
* assumptions changed,
* ideas added,
* ideas rejected,
* risks changed,
* and next actions.

## 8.13 AI Memory

The system must record retrievable memory items from:

* decisions,
* assumptions,
* business ideas,
* evidence,
* experiments,
* reviews,
* reports,
* and AI summaries.

Each memory item must reference its canonical source record.

---

# 9. What the System Does

Founder Decision OS should help the founder:

1. define founder constraints and goals,
2. create a structured idea bank,
3. classify and compare business ideas,
4. identify variables that affect business selection,
5. extract assumptions from business ideas,
6. collect and organize evidence,
7. design validation experiments,
8. score ideas consistently,
9. record decisions,
10. review decisions,
11. manage pivots,
12. detect contradictions,
13. identify low-confidence high-impact variables,
14. identify untested critical assumptions,
15. summarize evidence,
16. generate decision memos,
17. generate weekly reviews,
18. retrieve relevant prior context,
19. preserve the history of reasoning,
20. and prepare for future SaaS/productized use.

---

# 10. What the System Does Not Do

Founder Decision OS is not initially:

* a finished SaaS product,
* a complete web application,
* an accounting system,
* a CRM,
* a full project management suite,
* a legal advice engine,
* an investment advisor,
* a tax advisor,
* a pitch deck generator,
* a generic notes app,
* a replacement for customer conversations,
* a replacement for founder judgment,
* or a guarantee that a business will succeed.

The MVP may include scaffolding for future app, worker, AI, and Qdrant modules, but those modules must not pretend to be more complete than they are.

---

# 11. MVP Shape

The first version is a Foundation MVP.

It is not a tiny throwaway prototype.

It must provide the durable foundation for:

* local development,
* PostgreSQL/Supabase schema,
* pgvector memory layer,
* optional Qdrant sync model,
* seed records,
* verification scripts,
* SQL tests,
* documentation,
* prompt library,
* productization path,
* and future app/worker scaffolding.

The MVP should be complete enough that a founder can begin recording real business formation decisions while the system evolves.

---

# 12. Must-Have MVP Capabilities

The Foundation MVP must include:

* canonical PostgreSQL/Supabase schema,
* multi-tenant organization/workspace model,
* founder profile records,
* variable ledger,
* assumption ledger,
* business idea records,
* market records,
* customer segment records,
* problem records,
* offer records,
* evidence library,
* experiment tracker,
* decision register,
* risk register,
* review records,
* idea scorecards,
* memory item records,
* pgvector embedding support,
* optional Qdrant sync queue,
* seed records,
* verification SQL,
* SQL tests,
* setup scripts,
* documentation,
* and reusable prompt library.

---

# 13. Should-Have MVP Capabilities

The Foundation MVP should include:

* app scaffold,
* worker scaffold,
* shared packages,
* JSON schemas,
* backup/export scripts,
* GitHub CI workflows,
* report templates,
* troubleshooting docs,
* AI workflow policies,
* citation policy,
* retrieval policy,
* and memory policy.

These should be generated with complete scaffolding but do not need to become finished production features in v0.1.

---

# 14. Could-Have MVP Capabilities

The Foundation MVP may include optional support for:

* Qdrant runtime,
* Qdrant sync worker,
* Qdrant smoke tests,
* AI worker,
* report generation scripts,
* web UI,
* external AI embedding providers,
* and future SaaS billing hooks.

These must be disabled by default unless explicitly enabled.

---

# 15. Feature Flags

The system must support the following feature flags:

```env
ENABLE_QDRANT=false
ENABLE_AI_WORKER=false
ENABLE_REPORT_GENERATION=false
ENABLE_WEB_APP=false
ENABLE_SUPABASE_STORAGE=true
ENABLE_PGVECTOR=true
```

Optional systems must not break the core MVP when disabled.

---

# 16. Canonical Data Ownership

The following ownership rules are mandatory.

## 16.1 PostgreSQL/Supabase

Owns canonical data.

## 16.2 pgvector

Stores semantic embeddings for retrieval.

## 16.3 Qdrant

May store external retrieval indexes and payload references.

## 16.4 Supabase Storage

Stores raw files and evidence assets.

## 16.5 AI

Generates summaries, suggestions, classifications, prompts, and recommendations.

AI outputs must be stored and linked to source records.

AI does not own truth.

---

# 17. Initial Seed Decisions

The system must include these starter records.

## D-001

**Decision:** I will not randomly pick a business idea. I will use a documented decision system that records variables, assumptions, evidence, experiments, trade-offs, and decisions before committing to a business.

**Status:** active

## ADR-001

**Decision:** Use PostgreSQL/Supabase as the canonical brain, pgvector as the built-in semantic memory layer, and Qdrant as an optional external retrieval accelerator.

**Status:** active

## V-001

**Variable:** Founder available capital
**Category:** financial

## V-002

**Variable:** Available weekly time
**Category:** capacity

## V-003

**Variable:** Required monthly income
**Category:** financial

## V-004

**Variable:** Risk tolerance
**Category:** founder

## V-005

**Variable:** Desired business model
**Category:** business_model

## A-001

**Assumption:** A low-capital B2B business with AI-assisted fulfillment may be the best initial business shape to test.

**Status:** untested

## BI-001

**Business Idea:** Undecided Business Idea
**Status:** researching

---

# 18. Primary User Journey

The primary user journey is:

1. Founder records personal goals, constraints, and non-negotiables.
2. Founder records variables that affect business selection.
3. Founder adds possible business ideas.
4. System helps extract assumptions from each idea.
5. Founder collects evidence.
6. Founder designs validation experiments.
7. Founder scores ideas using consistent criteria.
8. Founder records decisions and trade-offs.
9. System helps review decisions and detect weak assumptions.
10. Founder chooses one idea to test for a defined period.
11. Founder reviews outcomes and either continues, pivots, or rejects the idea.
12. The system preserves the full reasoning trail.

---

# 19. Future Product Journey

The future SaaS/product journey is:

1. A user creates an account.
2. The user creates an organization and workspace.
3. The user completes founder profile onboarding.
4. The system creates starter ledgers and templates.
5. The user adds ideas and constraints.
6. The AI assistant helps classify, score, and retrieve context.
7. The user runs validation experiments.
8. The system generates decision memos and reviews.
9. The user selects, validates, or rejects business ideas.
10. The user can export reports, evidence, and decision history.

---

# 20. Success Criteria

The product is successful at the Foundation MVP stage if:

* the schema can store the full founder decision process,
* the founder can record variables, assumptions, ideas, evidence, experiments, decisions, risks, and reviews,
* starter records exist,
* migrations apply,
* seed data inserts,
* verification scripts exist,
* pgvector memory layer exists,
* Qdrant sync is optional,
* docs explain the system clearly,
* prompt library exists,
* and the system can evolve into a SaaS product without replacing the data model.

---

# 21. Non-Goals for Foundation MVP

The Foundation MVP does not need to include:

* a polished production UI,
* paid AI API integration,
* production billing,
* multi-tenant SaaS onboarding,
* full analytics dashboard,
* real-time collaboration,
* mobile app,
* enterprise SSO,
* production-grade reporting engine,
* or fully automated business recommendations.

These may be future roadmap items.

---

# 22. Product Risks

## 22.1 Overbuilding Risk

The system may become too complex before the founder gets practical value.

Mitigation:

* keep core records usable,
* make optional modules feature-flagged,
* prioritize database verification,
* ensure founder workflows remain understandable.

## 22.2 Schema Drift Risk

Docs, prompts, and code may drift from the database schema.

Mitigation:

* maintain table catalog,
* maintain enum catalog,
* run verification scripts,
* keep docs aligned with migrations.

## 22.3 AI Authority Risk

Users may treat AI-generated recommendations as truth.

Mitigation:

* AI outputs must cite canonical records,
* AI outputs are stored as summaries/recommendations, not facts,
* PostgreSQL remains the source of truth.

## 22.4 Retrieval Drift Risk

pgvector or Qdrant may return relevant-looking but incomplete context.

Mitigation:

* retrieve canonical records after semantic search,
* filter by organization/workspace,
* cite source records,
* log retrieval events.

## 22.5 Optional Dependency Risk

Optional systems may accidentally become required.

Mitigation:

* disable optional features by default,
* test core system with Qdrant disabled,
* use safe no-op behavior in workers.

---

# 23. Product Boundaries

Founder Decision OS should be opinionated enough to guide good decisions but flexible enough to support different business types.

It should favor:

* evidence over excitement,
* validation over guessing,
* structured memory over scattered notes,
* reversible decisions over premature commitment,
* founder fit over generic opportunity rankings,
* and clear audit trails over hidden reasoning.

It should not force every founder into the same business model.

---

# 24. Relationship to Applied Innovation Corp

Founder Decision OS may become part of Applied Innovation Corp’s broader mission to help businesses safely, repeatedly, and profitably convert AI into operations, automation, governance, software delivery, and measurable revenue.

It may also become a reusable system for:

* AI-assisted business formation,
* startup ideation,
* founder decision support,
* venture validation,
* AI cofounder memory,
* and productized consulting delivery.

The product should therefore be built with both personal use and future AIC productization in mind.

---

# 25. Definition of Done for This Charter

This product charter is complete when it defines:

* product name,
* alternative names,
* primary user,
* secondary users,
* product purpose,
* problem statement,
* product promise,
* what the system records,
* what the system does,
* what the system does not do,
* MVP shape,
* must-have capabilities,
* should-have capabilities,
* could-have capabilities,
* canonical architecture,
* source-of-truth rules,
* primary user journey,
* future product journey,
* success criteria,
* non-goals,
* risks,
* and relationship to future productization.

---

# 26. Charter Summary

Founder Decision OS is a structured decision and memory system for choosing what business to start.

It turns business ideation into an auditable process.

It records the founder’s constraints, variables, assumptions, evidence, experiments, scorecards, decisions, risks, reviews, and pivots.

It uses PostgreSQL/Supabase as the canonical brain, pgvector as built-in semantic memory, and optional Qdrant as an external retrieval accelerator.

It begins as a personal founder planning system but is intentionally designed as the foundation for a future SaaS product, AI cofounder memory system, or business ideation operating system.
