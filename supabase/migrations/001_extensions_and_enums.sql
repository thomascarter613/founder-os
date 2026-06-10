begin;

create schema if not exists extensions;

create extension if not exists pgcrypto with schema extensions;
create extension if not exists citext with schema extensions;

do $$
begin
  if exists (
    select 1
    from pg_available_extensions
    where name = 'vector'
  ) then
    execute 'create extension if not exists vector with schema extensions';
  else
    raise notice 'pgvector extension is not available in this environment; memory migrations that require vector must not run until it is installed.';
  end if;
end
$$;

do $$
begin
  if not exists (select 1 from pg_type where typname = 'workspace_role') then
    create type workspace_role as enum (
      'owner',
      'admin',
      'editor',
      'viewer'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'founder_stage') then
    create type founder_stage as enum (
      'exploring',
      'validating',
      'committed',
      'building',
      'paused',
      'archived'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'idea_status') then
    create type idea_status as enum (
      'captured',
      'screening',
      'researching',
      'validating',
      'prioritized',
      'rejected',
      'selected',
      'archived'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'assumption_status') then
    create type assumption_status as enum (
      'open',
      'queued',
      'testing',
      'validated',
      'invalidated',
      'superseded'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'evidence_type') then
    create type evidence_type as enum (
      'interview',
      'survey',
      'market_research',
      'competitor_analysis',
      'observation',
      'analytics',
      'prototype_feedback',
      'financial_model',
      'secondary_source',
      'ai_summary',
      'other'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'evidence_strength') then
    create type evidence_strength as enum (
      'weak',
      'moderate',
      'strong'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'experiment_status') then
    create type experiment_status as enum (
      'planned',
      'ready',
      'running',
      'completed',
      'cancelled',
      'superseded'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'decision_status') then
    create type decision_status as enum (
      'proposed',
      'active',
      'reversed',
      'superseded',
      'archived'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'review_status') then
    create type review_status as enum (
      'scheduled',
      'in_progress',
      'completed',
      'skipped',
      'cancelled'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'risk_level') then
    create type risk_level as enum (
      'low',
      'medium',
      'high',
      'critical'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'task_status') then
    create type task_status as enum (
      'backlog',
      'ready',
      'in_progress',
      'blocked',
      'done',
      'cancelled'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'attachment_type') then
    create type attachment_type as enum (
      'document',
      'image',
      'audio',
      'video',
      'spreadsheet',
      'link',
      'other'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'ai_record_kind') then
    create type ai_record_kind as enum (
      'prompt',
      'summary',
      'report',
      'recommendation',
      'classification',
      'embedding_job'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'memory_source_kind') then
    create type memory_source_kind as enum (
      'founder_profile',
      'business_idea',
      'assumption',
      'evidence',
      'experiment',
      'decision',
      'review',
      'risk',
      'task',
      'note',
      'ai_summary',
      'report'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'qdrant_sync_status') then
    create type qdrant_sync_status as enum (
      'pending',
      'processing',
      'synced',
      'failed',
      'skipped'
    );
  end if;
end
$$;

commit;
