begin;

create table if not exists public.memory_items (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  source_table text not null,
  source_record_id uuid not null,
  source_kind public.memory_source_kind not null,
  title text not null,
  content text not null,
  summary text,
  metadata jsonb not null default '{}'::jsonb,
  created_by_user_id uuid references public.user_accounts(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint memory_items_workspace_belongs_to_org_chk
    check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
);

do $$
begin
  if exists (
    select 1
    from pg_type t
    join pg_namespace n on n.oid = t.typnamespace
    where t.typname = 'vector'
      and n.nspname = 'extensions'
  ) then
    execute $sql$
      create table if not exists public.memory_embeddings (
        id uuid primary key default extensions.gen_random_uuid(),
        memory_item_id uuid not null references public.memory_items(id) on delete cascade,
        organization_id uuid not null references public.organizations(id) on delete cascade,
        workspace_id uuid not null references public.workspaces(id) on delete cascade,
        embedding extensions.vector(1536) not null,
        embedding_provider text not null,
        embedding_model text not null,
        embedding_dimensions integer not null,
        created_at timestamptz not null default timezone('utc', now()),
        updated_at timestamptz not null default timezone('utc', now()),
        constraint memory_embeddings_memory_item_id_key unique (memory_item_id),
        constraint memory_embeddings_workspace_belongs_to_org_chk
          check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
      )
    $sql$;
  else
    execute $sql$
      create table if not exists public.memory_embeddings (
        id uuid primary key default extensions.gen_random_uuid(),
        memory_item_id uuid not null references public.memory_items(id) on delete cascade,
        organization_id uuid not null references public.organizations(id) on delete cascade,
        workspace_id uuid not null references public.workspaces(id) on delete cascade,
        embedding_json jsonb not null,
        embedding_provider text not null,
        embedding_model text not null,
        embedding_dimensions integer not null,
        created_at timestamptz not null default timezone('utc', now()),
        updated_at timestamptz not null default timezone('utc', now()),
        constraint memory_embeddings_memory_item_id_key unique (memory_item_id),
        constraint memory_embeddings_workspace_belongs_to_org_chk
          check (public.ensure_workspace_belongs_to_organization(organization_id, workspace_id))
      )
    $sql$;
  end if;
end
$$;

create index if not exists memory_items_org_workspace_source_idx
  on public.memory_items (organization_id, workspace_id, source_table, source_record_id);

create index if not exists memory_items_source_kind_idx
  on public.memory_items (source_kind);

comment on table public.memory_items is
  'Canonical memory records derived from founder, idea, evidence, decision, and related source tables.';

comment on table public.memory_embeddings is
  'Embedding records for canonical memory items. Uses pgvector when available and a JSON fallback when pgvector is unavailable.';

commit;
