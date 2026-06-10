begin;

create table if not exists public.idea_assumptions (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  business_idea_id uuid not null references public.business_ideas(id) on delete cascade,
  founder_profile_id uuid not null references public.founder_profiles(id) on delete cascade,
  code text not null,
  title text not null,
  description text not null,
  category text not null,
  status public.assumption_status not null default 'open',
  confidence_score numeric(5,2),
  validation_priority public.risk_level not null default 'medium',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint idea_assumptions_org_workspace_code_key unique (organization_id, workspace_id, code),
  constraint idea_assumptions_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.evidence_records (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  business_idea_id uuid references public.business_ideas(id) on delete set null,
  opportunity_signal_id uuid references public.opportunity_signals(id) on delete set null,
  code text not null,
  title text not null,
  summary text not null,
  evidence_type public.evidence_type not null,
  evidence_strength public.evidence_strength not null default 'moderate',
  source_name text,
  source_link text,
  collected_on date,
  created_by_user_id uuid references public.user_accounts(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint evidence_records_org_workspace_code_key unique (organization_id, workspace_id, code),
  constraint evidence_records_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.experiments (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  business_idea_id uuid not null references public.business_ideas(id) on delete cascade,
  code text not null,
  title text not null,
  hypothesis text not null,
  description text,
  experiment_status public.experiment_status not null default 'planned',
  success_metric text,
  start_date date,
  end_date date,
  outcome_summary text,
  created_by_user_id uuid references public.user_accounts(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint experiments_org_workspace_code_key unique (organization_id, workspace_id, code),
  constraint experiments_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.assumption_evidence_links (
  id uuid primary key default extensions.gen_random_uuid(),
  idea_assumption_id uuid not null references public.idea_assumptions(id) on delete cascade,
  evidence_record_id uuid not null references public.evidence_records(id) on delete cascade,
  relationship_note text,
  created_at timestamptz not null default timezone('utc', now()),
  constraint assumption_evidence_links_assumption_evidence_key unique (idea_assumption_id, evidence_record_id)
);

create table if not exists public.experiment_assumptions (
  id uuid primary key default extensions.gen_random_uuid(),
  experiment_id uuid not null references public.experiments(id) on delete cascade,
  idea_assumption_id uuid not null references public.idea_assumptions(id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  constraint experiment_assumptions_experiment_assumption_key unique (experiment_id, idea_assumption_id)
);

create table if not exists public.experiment_evidence_links (
  id uuid primary key default extensions.gen_random_uuid(),
  experiment_id uuid not null references public.experiments(id) on delete cascade,
  evidence_record_id uuid not null references public.evidence_records(id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  constraint experiment_evidence_links_experiment_evidence_key unique (experiment_id, evidence_record_id)
);

create index if not exists idea_assumptions_business_idea_id_idx
  on public.idea_assumptions (business_idea_id);

create index if not exists idea_assumptions_status_idx
  on public.idea_assumptions (status);

create index if not exists evidence_records_business_idea_id_idx
  on public.evidence_records (business_idea_id);

create index if not exists evidence_records_evidence_type_idx
  on public.evidence_records (evidence_type);

create index if not exists experiments_business_idea_id_idx
  on public.experiments (business_idea_id);

create index if not exists experiments_experiment_status_idx
  on public.experiments (experiment_status);

create index if not exists assumption_evidence_links_evidence_record_id_idx
  on public.assumption_evidence_links (evidence_record_id);

create index if not exists experiment_assumptions_idea_assumption_id_idx
  on public.experiment_assumptions (idea_assumption_id);

create index if not exists experiment_evidence_links_evidence_record_id_idx
  on public.experiment_evidence_links (evidence_record_id);

comment on table public.idea_assumptions is
  'Explicit business assumptions attached to ideas and tracked through validation states.';

comment on table public.evidence_records is
  'Canonical evidence records collected for or against business ideas and opportunity signals.';

comment on table public.experiments is
  'Validation experiments designed to test business assumptions and hypotheses.';

comment on table public.assumption_evidence_links is
  'Join table connecting assumptions to evidence records.';

comment on table public.experiment_assumptions is
  'Join table connecting experiments to the assumptions they are meant to test.';

comment on table public.experiment_evidence_links is
  'Join table connecting experiments to the evidence generated or used by them.';

commit;
