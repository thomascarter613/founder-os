begin;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

comment on function public.set_updated_at() is
  'Shared trigger function for tables that maintain an updated_at timestamp.';

create or replace function public.ensure_workspace_belongs_to_organization(
  input_organization_id uuid,
  input_workspace_id uuid
)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.workspaces
    where id = input_workspace_id
      and organization_id = input_organization_id
  );
$$;

comment on function public.ensure_workspace_belongs_to_organization(uuid, uuid) is
  'Helper for validating that a workspace belongs to the expected organization.';

comment on table public.user_accounts is
  'Canonical user profile table for product-level identity metadata linked to auth users when available.';

comment on table public.organizations is
  'Top-level tenant boundary for Founder Decision OS. Future domain tables should reference organization_id when records are tenant-scoped.';

comment on table public.workspaces is
  'Primary working boundary inside an organization. Future founder decision records should usually reference workspace_id and organization_id together.';

comment on table public.organization_memberships is
  'Membership mapping between user accounts and organizations.';

comment on table public.workspace_memberships is
  'Membership mapping between user accounts and workspaces.';

commit;
