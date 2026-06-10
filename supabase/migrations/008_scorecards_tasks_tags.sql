begin;

create table if not exists public.idea_scorecards (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  business_idea_id uuid not null references public.business_ideas(id) on delete cascade,
  founder_profile_id uuid not null references public.founder_profiles(id) on delete cascade,
  score_name text not null,
  criterion text not null,
  score_value numeric(5,2) not null,
  weight numeric(5,2),
  justification text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint idea_scorecards_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.execution_tasks (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  founder_profile_id uuid references public.founder_profiles(id) on delete set null,
  business_idea_id uuid references public.business_ideas(id) on delete set null,
  decision_id uuid references public.decisions(id) on delete set null,
  experiment_id uuid references public.experiments(id) on delete set null,
  code text not null,
  title text not null,
  description text,
  task_status public.task_status not null default 'backlog',
  due_date date,
  assignee_user_id uuid references public.user_accounts(id) on delete set null,
  created_by_user_id uuid references public.user_accounts(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint execution_tasks_org_workspace_code_key unique (organization_id, workspace_id, code),
  constraint execution_tasks_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.tags (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  label text not null,
  description text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint tags_org_workspace_label_key unique (organization_id, workspace_id, label),
  constraint tags_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.record_tag_links (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  tag_id uuid not null references public.tags(id) on delete cascade,
  source_table text not null,
  source_record_id uuid not null,
  created_at timestamptz not null default timezone('utc', now()),
  constraint record_tag_links_org_workspace_tag_source_key unique (
    organization_id,
    workspace_id,
    tag_id,
    source_table,
    source_record_id
  ),
  constraint record_tag_links_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.attachments (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  source_table text not null,
  source_record_id uuid not null,
  attachment_type public.attachment_type not null,
  file_name text not null,
  storage_bucket text,
  storage_path text,
  external_url text,
  created_by_user_id uuid references public.user_accounts(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint attachments_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.record_links (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  from_table text not null,
  from_record_id uuid not null,
  to_table text not null,
  to_record_id uuid not null,
  relationship_type text not null,
  note text,
  created_at timestamptz not null default timezone('utc', now()),
  constraint record_links_org_workspace_from_to_key unique (
    organization_id,
    workspace_id,
    from_table,
    from_record_id,
    to_table,
    to_record_id,
    relationship_type
  ),
  constraint record_links_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create index if not exists idea_scorecards_business_idea_id_idx
  on public.idea_scorecards (business_idea_id);

create index if not exists execution_tasks_business_idea_id_idx
  on public.execution_tasks (business_idea_id);

create index if not exists execution_tasks_decision_id_idx
  on public.execution_tasks (decision_id);

create index if not exists execution_tasks_experiment_id_idx
  on public.execution_tasks (experiment_id);

create index if not exists execution_tasks_task_status_idx
  on public.execution_tasks (task_status);

create index if not exists record_tag_links_source_idx
  on public.record_tag_links (source_table, source_record_id);

create index if not exists attachments_source_idx
  on public.attachments (source_table, source_record_id);

create index if not exists record_links_from_idx
  on public.record_links (from_table, from_record_id);

create index if not exists record_links_to_idx
  on public.record_links (to_table, to_record_id);

comment on table public.idea_scorecards is
  'Scoring criteria and weighted scores used to compare business ideas.';

comment on table public.execution_tasks is
  'Actionable execution tasks linked to ideas, decisions, and experiments.';

comment on table public.tags is
  'Reusable workspace tags for classifying records.';

comment on table public.record_tag_links is
  'Polymorphic tag assignment table for canonical records.';

comment on table public.attachments is
  'Metadata for files and external attachments linked to canonical records.';

comment on table public.record_links is
  'Generic cross-record relationship table for canonical records that need explicit linkage.';

commit;
