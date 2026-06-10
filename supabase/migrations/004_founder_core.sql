begin;

create table if not exists public.founder_profiles (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  user_account_id uuid references public.user_accounts(id) on delete set null,
  code text not null,
  display_name text not null,
  biography text,
  location text,
  timezone text,
  founder_stage public.founder_stage not null default 'exploring',
  primary_motivation text,
  availability_summary text,
  risk_tolerance text,
  capital_profile text,
  current_context text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint founder_profiles_org_workspace_code_key unique (organization_id, workspace_id, code),
  constraint founder_profiles_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.founder_constraints (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  founder_profile_id uuid not null references public.founder_profiles(id) on delete cascade,
  constraint_name text not null,
  constraint_type text not null,
  description text not null,
  severity public.risk_level not null default 'medium',
  is_hard_constraint boolean not null default false,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint founder_constraints_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.founder_goals (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  founder_profile_id uuid not null references public.founder_profiles(id) on delete cascade,
  goal_name text not null,
  goal_type text not null,
  description text,
  target_date date,
  success_definition text,
  priority public.risk_level not null default 'medium',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint founder_goals_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.founder_notes (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  founder_profile_id uuid not null references public.founder_profiles(id) on delete cascade,
  title text not null,
  body text not null,
  note_type text not null default 'general',
  created_by_user_id uuid references public.user_accounts(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint founder_notes_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create index if not exists founder_profiles_workspace_id_idx
  on public.founder_profiles (workspace_id);

create index if not exists founder_profiles_user_account_id_idx
  on public.founder_profiles (user_account_id);

create index if not exists founder_constraints_founder_profile_id_idx
  on public.founder_constraints (founder_profile_id);

create index if not exists founder_goals_founder_profile_id_idx
  on public.founder_goals (founder_profile_id);

create index if not exists founder_notes_founder_profile_id_idx
  on public.founder_notes (founder_profile_id);

comment on table public.founder_profiles is
  'Canonical founder profile and operating-context table for a workspace.';

comment on table public.founder_constraints is
  'Explicit founder constraints that should shape business selection and validation.';

comment on table public.founder_goals is
  'Founder goals and success definitions used to judge opportunities and tradeoffs.';

comment on table public.founder_notes is
  'Freeform founder operating notes that remain canonical records inside PostgreSQL.';

commit;
