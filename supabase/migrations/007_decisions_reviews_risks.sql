begin;

create table if not exists public.decisions (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  founder_profile_id uuid not null references public.founder_profiles(id) on delete cascade,
  business_idea_id uuid references public.business_ideas(id) on delete set null,
  code text not null,
  title text not null,
  decision_status public.decision_status not null default 'proposed',
  decision_date date not null,
  summary text not null,
  rationale text not null,
  options_considered text,
  expected_upside text,
  expected_downside text,
  made_by_user_id uuid references public.user_accounts(id) on delete set null,
  supersedes_decision_id uuid references public.decisions(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint decisions_org_workspace_code_key unique (organization_id, workspace_id, code),
  constraint decisions_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.decision_reviews (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  decision_id uuid not null references public.decisions(id) on delete cascade,
  review_status public.review_status not null default 'scheduled',
  scheduled_for date not null,
  reviewed_on date,
  review_summary text,
  outcome_assessment text,
  follow_up_note text,
  reviewed_by_user_id uuid references public.user_accounts(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint decision_reviews_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.risks (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  founder_profile_id uuid references public.founder_profiles(id) on delete set null,
  business_idea_id uuid references public.business_ideas(id) on delete set null,
  decision_id uuid references public.decisions(id) on delete set null,
  code text not null,
  title text not null,
  description text not null,
  risk_level public.risk_level not null default 'medium',
  mitigation_plan text,
  owner_user_id uuid references public.user_accounts(id) on delete set null,
  identified_on date,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint risks_org_workspace_code_key unique (organization_id, workspace_id, code),
  constraint risks_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.pivots (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  founder_profile_id uuid not null references public.founder_profiles(id) on delete cascade,
  from_business_idea_id uuid references public.business_ideas(id) on delete set null,
  to_business_idea_id uuid references public.business_ideas(id) on delete set null,
  trigger_decision_id uuid references public.decisions(id) on delete set null,
  code text not null,
  pivot_date date not null,
  summary text not null,
  reason text not null,
  expected_change text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint pivots_org_workspace_code_key unique (organization_id, workspace_id, code),
  constraint pivots_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.decision_evidence_links (
  id uuid primary key default extensions.gen_random_uuid(),
  decision_id uuid not null references public.decisions(id) on delete cascade,
  evidence_record_id uuid not null references public.evidence_records(id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  constraint decision_evidence_links_decision_evidence_key unique (decision_id, evidence_record_id)
);

create table if not exists public.decision_assumption_links (
  id uuid primary key default extensions.gen_random_uuid(),
  decision_id uuid not null references public.decisions(id) on delete cascade,
  idea_assumption_id uuid not null references public.idea_assumptions(id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  constraint decision_assumption_links_decision_assumption_key unique (decision_id, idea_assumption_id)
);

create index if not exists decisions_founder_profile_id_idx
  on public.decisions (founder_profile_id);

create index if not exists decisions_business_idea_id_idx
  on public.decisions (business_idea_id);

create index if not exists decisions_decision_status_idx
  on public.decisions (decision_status);

create index if not exists decision_reviews_decision_id_idx
  on public.decision_reviews (decision_id);

create index if not exists decision_reviews_scheduled_for_idx
  on public.decision_reviews (scheduled_for);

create index if not exists risks_business_idea_id_idx
  on public.risks (business_idea_id);

create index if not exists risks_decision_id_idx
  on public.risks (decision_id);

create index if not exists risks_risk_level_idx
  on public.risks (risk_level);

create index if not exists pivots_from_business_idea_id_idx
  on public.pivots (from_business_idea_id);

create index if not exists pivots_to_business_idea_id_idx
  on public.pivots (to_business_idea_id);

create index if not exists decision_evidence_links_evidence_record_id_idx
  on public.decision_evidence_links (evidence_record_id);

create index if not exists decision_assumption_links_idea_assumption_id_idx
  on public.decision_assumption_links (idea_assumption_id);

comment on table public.decisions is
  'Canonical decision ledger for founder choices, rationale, and supersession relationships.';

comment on table public.decision_reviews is
  'Scheduled and completed reviews of prior decisions.';

comment on table public.risks is
  'Risks attached to founder context, ideas, and decisions.';

comment on table public.pivots is
  'Explicit pivot records describing directional changes between ideas or operating paths.';

comment on table public.decision_evidence_links is
  'Join table linking decisions to the evidence records used in those decisions.';

comment on table public.decision_assumption_links is
  'Join table linking decisions to the assumptions that influenced them.';

commit;
