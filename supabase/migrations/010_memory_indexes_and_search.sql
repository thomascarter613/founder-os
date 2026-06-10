begin;

create index if not exists memory_items_workspace_kind_idx
  on public.memory_items (organization_id, workspace_id, source_kind);

create index if not exists memory_items_created_at_idx
  on public.memory_items (created_at desc);

create index if not exists memory_embeddings_org_workspace_idx
  on public.memory_embeddings (organization_id, workspace_id);

do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'memory_embeddings'
      and column_name = 'embedding'
  ) then
    execute 'create index if not exists memory_embeddings_embedding_ivfflat_idx on public.memory_embeddings using ivfflat (embedding extensions.vector_cosine_ops) with (lists = 100)';
  end if;
end
$$;

create or replace function public.search_memory_items(
  input_organization_id uuid,
  input_workspace_id uuid,
  input_query text,
  input_limit integer default 10
)
returns table (
  memory_item_id uuid,
  source_table text,
  source_record_id uuid,
  source_kind public.memory_source_kind,
  title text,
  content text,
  summary text,
  match_reason text
)
language plpgsql
stable
as $$
declare
  has_vector boolean;
begin
  select exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'memory_embeddings'
      and column_name = 'embedding'
  )
  into has_vector;

  if has_vector then
    return query
      select
        mi.id,
        mi.source_table,
        mi.source_record_id,
        mi.source_kind,
        mi.title,
        mi.content,
        mi.summary,
        'vector-ready-schema-text-fallback'::text
      from public.memory_items mi
      where mi.organization_id = input_organization_id
        and mi.workspace_id = input_workspace_id
        and (
          mi.title ilike '%' || input_query || '%'
          or mi.content ilike '%' || input_query || '%'
          or coalesce(mi.summary, '') ilike '%' || input_query || '%'
        )
      order by mi.updated_at desc
      limit greatest(input_limit, 1);
  else
    return query
      select
        mi.id,
        mi.source_table,
        mi.source_record_id,
        mi.source_kind,
        mi.title,
        mi.content,
        mi.summary,
        'text-fallback'::text
      from public.memory_items mi
      where mi.organization_id = input_organization_id
        and mi.workspace_id = input_workspace_id
        and (
          mi.title ilike '%' || input_query || '%'
          or mi.content ilike '%' || input_query || '%'
          or coalesce(mi.summary, '') ilike '%' || input_query || '%'
        )
      order by mi.updated_at desc
      limit greatest(input_limit, 1);
  end if;
end
$$;

comment on function public.search_memory_items(uuid, uuid, text, integer) is
  'Tenant-aware memory search helper that falls back to text matching when vector search is unavailable.';

commit;
