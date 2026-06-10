begin;

create table if not exists public.user_accounts (
  id uuid primary key default extensions.gen_random_uuid(),
  auth_user_id uuid unique,
  email extensions.citext not null unique,
  display_name text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.organizations (
  id uuid primary key default extensions.gen_random_uuid(),
  slug extensions.citext not null unique,
  name text not null,
  description text,
  owner_user_id uuid not null references public.user_accounts(id),
  is_personal boolean not null default false,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.workspaces (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  slug extensions.citext not null,
  name text not null,
  description text,
  owner_user_id uuid not null references public.user_accounts(id),
  is_default boolean not null default false,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint workspaces_org_slug_key unique (organization_id, slug)
);

create table if not exists public.organization_memberships (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  user_account_id uuid not null references public.user_accounts(id) on delete cascade,
  role public.workspace_role not null default 'viewer',
  is_primary boolean not null default false,
  joined_at timestamptz not null default timezone('utc', now()),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint organization_memberships_org_user_key unique (organization_id, user_account_id)
);

create table if not exists public.workspace_memberships (
  id uuid primary key default extensions.gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  user_account_id uuid not null references public.user_accounts(id) on delete cascade,
  role public.workspace_role not null default 'viewer',
  is_default boolean not null default false,
  joined_at timestamptz not null default timezone('utc', now()),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint workspace_memberships_workspace_user_key unique (workspace_id, user_account_id)
);

create index if not exists organizations_owner_user_id_idx
  on public.organizations (owner_user_id);

create index if not exists workspaces_organization_id_idx
  on public.workspaces (organization_id);

create index if not exists workspaces_owner_user_id_idx
  on public.workspaces (owner_user_id);

create index if not exists organization_memberships_user_account_id_idx
  on public.organization_memberships (user_account_id);

create index if not exists workspace_memberships_user_account_id_idx
  on public.workspace_memberships (user_account_id);

commit;
