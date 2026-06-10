# Embedding Scripts

These scripts manage canonical memory embeddings for Founder Decision OS.

They follow these rules:

- PostgreSQL remains the source of truth.
- `memory_items` is the canonical memory record table.
- `memory_embeddings` stores derived embedding data linked to `memory_items`.
- When pgvector is unavailable, the scripts work against the JSON fallback column introduced by the memory schema migration.

## Prerequisites

- `psql` must be installed and available on `PATH`.
- A TypeScript runner must be available, such as `tsx` or `ts-node`.
- `DATABASE_URL` or `SUPABASE_DB_URL` must point to the canonical PostgreSQL database.
- `OPENAI_API_KEY` is required for scripts that request new embeddings.

## Environment

- `DATABASE_URL` or `SUPABASE_DB_URL`: canonical database connection string
- `OPENAI_API_KEY`: embedding provider credential
- `VECTOR_EMBEDDING_MODEL`: defaults to `text-embedding-3-small`
- `VECTOR_EMBEDDING_PROVIDER`: defaults to `openai`
- `VECTOR_EMBEDDING_DIMENSIONS`: defaults to `1536`
- `EMBED_LIMIT`: optional batch limit for `embed-memory-items.ts`
- `REEMBED_LIMIT`: optional batch limit for `reembed-memory-items.ts`
- `REEMBED_ALL=true`: force re-embedding of all memory items

## Scripts

- `embed-memory-items.ts`: embeds memory items that do not yet have embeddings
- `reembed-memory-items.ts`: re-embeds items when the provider, model, or dimensions have changed, or when forced
- `verify-embeddings.ts`: verifies that memory items and memory embeddings line up

## Notes

- These scripts do not make Qdrant canonical and do not depend on Qdrant.
- Until a package runner is added to the repository, execution is intentionally manual.
