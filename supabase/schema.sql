-- eZZa planner: database schema for Supabase.
-- Run this once: Supabase dashboard → SQL Editor → New query → paste → Run.
-- Row Level Security is on for both tables: every person can read and write only their own rows.

create table if not exists public.tasks (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  title       text not null check (char_length(title) between 1 and 300),
  project     text,
  platforms   text[] not null default '{}',
  date        date,
  note        text not null default '' check (char_length(note) <= 5000),
  done        boolean not null default false,
  done_at     timestamptz,
  sample      boolean not null default false,
  created_at  timestamptz not null default now()
);

create index if not exists tasks_user_date_idx on public.tasks (user_id, date);
create index if not exists tasks_user_created_idx on public.tasks (user_id, created_at);

create table if not exists public.settings (
  user_id     uuid primary key default auth.uid() references auth.users (id) on delete cascade,
  projects    jsonb not null default '[]'::jsonb,
  platforms   jsonb not null default '[]'::jsonb,
  updated_at  timestamptz not null default now()
);

alter table public.tasks    enable row level security;
alter table public.settings enable row level security;

drop policy if exists "tasks: own rows"    on public.tasks;
drop policy if exists "settings: own row"  on public.settings;

create policy "tasks: own rows" on public.tasks
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "settings: own row" on public.settings
  for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
