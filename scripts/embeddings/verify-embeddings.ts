import { execFileSync } from "node:child_process";

type SummaryRow = {
  memory_item_count: number;
  memory_embedding_count: number;
  missing_embedding_count: number;
  schema_mode: string;
};

function getDatabaseUrl(): string | null {
  return process.env.DATABASE_URL ?? process.env.SUPABASE_DB_URL ?? null;
}

function runPsql(databaseUrl: string, sql: string): string {
  try {
    return execFileSync(
      "psql",
      ["--dbname", databaseUrl, "-X", "-v", "ON_ERROR_STOP=1", "-At", "-c", sql],
      { encoding: "utf8" },
    ).trim();
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    throw new Error(`psql command failed: ${message}`);
  }
}

function queryJson<T>(databaseUrl: string, sql: string): T[] {
  const wrapped = `select coalesce(json_agg(row_to_json(t)), '[]'::json)::text from (${sql}) t;`;
  const raw = runPsql(databaseUrl, wrapped);
  return JSON.parse(raw || "[]") as T[];
}

function getSummary(databaseUrl: string): SummaryRow {
  const rows = queryJson<SummaryRow>(
    databaseUrl,
    `
      with schema_mode as (
        select case
          when exists (
            select 1
            from information_schema.columns
            where table_schema = 'public'
              and table_name = 'memory_embeddings'
              and column_name = 'embedding'
          ) then 'vector'
          else 'json'
        end as schema_mode
      )
      select
        (select count(*)::int from public.memory_items) as memory_item_count,
        (select count(*)::int from public.memory_embeddings) as memory_embedding_count,
        (
          select count(*)::int
          from public.memory_items mi
          left join public.memory_embeddings me on me.memory_item_id = mi.id
          where me.id is null
        ) as missing_embedding_count,
        (select schema_mode from schema_mode) as schema_mode
    `,
  );

  return rows[0] ?? {
    memory_item_count: 0,
    memory_embedding_count: 0,
    missing_embedding_count: 0,
    schema_mode: "unknown",
  };
}

function main(): void {
  const databaseUrl = getDatabaseUrl();
  if (!databaseUrl) {
    console.log("No DATABASE_URL or SUPABASE_DB_URL found. Nothing to verify.");
    return;
  }

  const summary = getSummary(databaseUrl);
  console.log(JSON.stringify(summary, null, 2));

  if (summary.memory_item_count > 0 && summary.missing_embedding_count > 0) {
    console.error("Some memory items are missing embeddings.");
    process.exitCode = 1;
  }
}

main();
