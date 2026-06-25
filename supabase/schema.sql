-- ============================================================
--  Studio Legno – Supabase Schema
--  Rodar no: app.supabase.com → SQL Editor → New Query
-- ============================================================

-- ── Cenas (projetos 3D salvos) ────────────────────────────
create table if not exists scenes (
  id          uuid primary key default gen_random_uuid(),
  name        text not null default 'Sem título',
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- ── Objetos dentro de uma cena ───────────────────────────
create table if not exists scene_objects (
  id        uuid primary key default gen_random_uuid(),
  scene_id  uuid references scenes(id) on delete cascade,
  type      text not null,          -- box | cylinder | sphere
  w         numeric not null default 1,
  h         numeric not null default 1,
  d         numeric not null default 1,
  pos_x     numeric not null default 0,
  pos_y     numeric not null default 0.5,
  pos_z     numeric not null default 0
);

-- ── Catálogo de móveis ────────────────────────────────────
create table if not exists catalog (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  category    text,
  price       numeric,
  width       numeric,
  height      numeric,
  depth       numeric,
  description text,
  created_at  timestamptz default now()
);

-- ── Clientes ─────────────────────────────────────────────
create table if not exists clients (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  email      text,
  phone      text,
  created_at timestamptz default now()
);

-- ── Orçamentos ───────────────────────────────────────────
create table if not exists quotes (
  id         uuid primary key default gen_random_uuid(),
  client_id  uuid references clients(id),
  scene_id   uuid references scenes(id),
  status     text default 'rascunho',  -- rascunho | enviado | aprovado | recusado
  total      numeric,
  notes      text,
  created_at timestamptz default now()
);

-- ── Itens do orçamento ───────────────────────────────────
create table if not exists quote_items (
  id          uuid primary key default gen_random_uuid(),
  quote_id    uuid references quotes(id) on delete cascade,
  catalog_id  uuid references catalog(id),
  name        text not null,
  quantity    int default 1,
  unit_price  numeric,
  w           numeric,
  h           numeric,
  d           numeric
);

-- ============================================================
--  Row Level Security – modo dev (aberto para anon)
--  Trocar por políticas com auth.uid() antes de ir para produção
-- ============================================================
alter table scenes       enable row level security;
alter table scene_objects enable row level security;
alter table catalog      enable row level security;
alter table clients      enable row level security;
alter table quotes       enable row level security;
alter table quote_items  enable row level security;

create policy "dev: allow all" on scenes        for all to anon using (true) with check (true);
create policy "dev: allow all" on scene_objects for all to anon using (true) with check (true);
create policy "dev: allow all" on catalog       for all to anon using (true) with check (true);
create policy "dev: allow all" on clients       for all to anon using (true) with check (true);
create policy "dev: allow all" on quotes        for all to anon using (true) with check (true);
create policy "dev: allow all" on quote_items   for all to anon using (true) with check (true);
