import { execFileSync } from "node:child_process";

type SchemaMode = "vector" | "json";

type MemoryItemRow = {
  id: string;
  organization_id: string;
  workspace_id: string;
  title: string;
  content: string;
  summary: string | null;
};

function getDatabaseUrl(): string | null {
  return process.env.DATABASE_URL ?? process.env.SUPABASE_DB_URL ?? null;
}

function sqlString(value: string | null): string {
  if (value === null) {
    return "null";
  }

  return `'${value.replace(/'/g, "''")}'`;
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

function detectSchemaMode(databaseUrl: string): SchemaMode {
  const raw = runPsql(
    databaseUrl,
    `
      select case
        when exists (
          select 1
          from information_schema.columns
          where table_schema = 'public'
            and table_name = 'memory_embeddings'
            and column_name = 'embedding'
        ) then 'vector'
        else 'json'
      end;
    `,
  );

  return raw === "vector" ? "vector" : "json";
}

function getPendingItems(databaseUrl: string, limit: number): MemoryItemRow[] {
  return queryJson<MemoryItemRow>(
    databaseUrl,
    `
      select
        mi.id,
        mi.organization_id,
        mi.workspace_id,
        mi.title,
        mi.content,
        mi.summary
      from public.memory_items mi
      left join public.memory_embeddings me on me.memory_item_id = mi.id
      where me.id is null
      order by mi.created_at asc
      limit ${limit}
    `,
  );
}

async function requestEmbedding(input: string, model: string, dimensions: number): Promise<number[]> {
  const apiKey = process.env.OPENAI_API_KEY;

  if (!apiKey) {
    throw new Error("OPENAI_API_KEY is required to request embeddings.");
  }

  const response = await fetch("https://api.openai.com/v1/embeddings", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      authorization: `Bearer ${apiKey}`,
    },
    body: JSON.stringify({
      input,
      model,
      dimensions,
    }),
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`OpenAI embeddings request failed: ${response.status} ${errorText}`);
  }

  const payload = (await response.json()) as {
    data?: Array<{ embedding?: number[] }>;
  };

  const embedding = payload.data?.[0]?.embedding;
  if (!embedding) {
    throw new Error("Embedding response did not include an embedding vector.");
  }

  return embedding;
}

function buildEmbeddingInput(item: MemoryItemRow): string {
  return [item.title, item.summary ?? "", item.content].filter(Boolean).join("\n\n");
}

function upsertEmbedding(
  databaseUrl: string,
  schemaMode: SchemaMode,
  item: MemoryItemRow,
  embedding: number[],
  provider: string,
  model: string,
  dimensions: number,
): void {
  const vectorLiteral = `[${embedding.join(",")}]`;
  const jsonLiteral = JSON.stringify(embedding);

  const columnSql =
    schemaMode === "vector"
      ? `embedding = ${sqlString(vectorLiteral)}::extensions.vector`
      : `embedding_json = ${sqlString(jsonLiteral)}::jsonb`;

  runPsql(
    databaseUrl,
    `
      insert into public.memory_embeddings (
        memory_item_id,
        organization_id,
        workspace_id,
        ${schemaMode === "vector" ? "embedding," : "embedding_json,"}
        embedding_provider,
        embedding_model,
        embedding_dimensions
      ) values (
        ${sqlString(item.id)}::uuid,
        ${sqlString(item.organization_id)}::uuid,
        ${sqlString(item.workspace_id)}::uuid,
        ${schemaMode === "vector" ? `${sqlString(vectorLiteral)}::extensions.vector,` : `${sqlString(jsonLiteral)}::jsonb,`}
        ${sqlString(provider)},
        ${sqlString(model)},
        ${dimensions}
      )
      on conflict (memory_item_id) do update
      set
        ${columnSql},
        embedding_provider = excluded.embedding_provider,
        embedding_model = excluded.embedding_model,
        embedding_dimensions = excluded.embedding_dimensions,
        updated_at = timezone('utc', now());
    `,
  );
}

async function main(): Promise<void> {
  const databaseUrl = getDatabaseUrl();
  if (!databaseUrl) {
    console.log("No DATABASE_URL or SUPABASE_DB_URL found. Nothing to do.");
    return;
  }

  const limit = Number(process.env.EMBED_LIMIT ?? "25");
  const provider = process.env.VECTOR_EMBEDDING_PROVIDER ?? "openai";
  const model = process.env.VECTOR_EMBEDDING_MODEL ?? "text-embedding-3-small";
  const dimensions = Number(process.env.VECTOR_EMBEDDING_DIMENSIONS ?? "1536");
  const schemaMode = detectSchemaMode(databaseUrl);
  const items = getPendingItems(databaseUrl, limit);

  if (items.length === 0) {
    console.log("No memory items are missing embeddings.");
    return;
  }

  for (const item of items) {
    const embedding = await requestEmbedding(buildEmbeddingInput(item), model, dimensions);
    upsertEmbedding(databaseUrl, schemaMode, item, embedding, provider, model, dimensions);
    console.log(`Embedded memory item ${item.id} using ${provider}/${model}.`);
  }
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
});
