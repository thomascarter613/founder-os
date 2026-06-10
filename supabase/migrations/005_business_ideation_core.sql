begin;

create table if not exists public.opportunity_areas (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  founder_profile_id uuid not null references public.founder_profiles(id) on delete cascade,
  code text not null,
  name text not null,
  description text,
  market_theme text,
  problem_space text,
  target_customer text,
  founder_fit_summary text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint opportunity_areas_org_workspace_code_key unique (organization_id, workspace_id, code),
  constraint opportunity_areas_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.business_ideas (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  founder_profile_id uuid not null references public.founder_profiles(id) on delete cascade,
  opportunity_area_id uuid references public.opportunity_areas(id) on delete set null,
  code text not null,
  name text not null,
  one_line_summary text not null,
  description text,
  status public.idea_status not null default 'captured',
  customer_segment text,
  problem_statement text,
  proposed_solution text,
  revenue_model text,
  acquisition_channel text,
  market_scope text,
  why_now text,
  founder_fit_score numeric(5,2),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint business_ideas_org_workspace_code_key unique (organization_id, workspace_id, code),
  constraint business_ideas_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.idea_themes (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  label text not null,
  description text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint idea_themes_org_workspace_label_key unique (organization_id, workspace_id, label),
  constraint idea_themes_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create table if not exists public.business_idea_themes (
  id uuid primary key default extensions.gen_random_uuid(),
  business_idea_id uuid not null references public.business_ideas(id) on delete cascade,
  idea_theme_id uuid not null references public.idea_themes(id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  constraint business_idea_themes_idea_theme_key unique (business_idea_id, idea_theme_id)
);

create table if not exists public.opportunity_signals (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  business_idea_id uuid not null references public.business_ideas(id) on delete cascade,
  signal_name text not null,
  signal_type text not null,
  description text not null,
  source_summary text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint opportunity_signals_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

create index if not exists opportunity_areas_founder_profile_id_idx
  on public.opportunity_areas (founder_profile_id);

create index if not exists business_ideas_founder_profile_id_idx
  on public.business_ideas (founder_profile_id);

create index if not exists business_ideas_opportunity_area_id_idx
  on public.business_ideas (opportunity_area_id);

create index if not exists business_ideas_status_idx
  on public.business_ideas (status);

create index if not exists business_idea_themes_idea_theme_id_idx
  on public.business_idea_themes (idea_theme_id);

create index if not exists opportunity_signals_business_idea_id_idx
  on public.opportunity_signals (business_idea_id);

comment on table public.opportunity_areas is
  'High-level opportunity spaces the founder wants to explore before or alongside concrete business ideas.';

comment on table public.business_ideas is
  'Canonical business ideas linked to founder context and used as the core ideation entity.';

comment on table public.idea_themes is
  'Reusable tags and themes for grouping related business ideas inside a workspace.';

comment on table public.business_idea_themes is
  'Join table linking business ideas to reusable themes.';

comment on table public.opportunity_signals is
  'Early signals that suggest why a business idea or opportunity area may matter.';

commit;
