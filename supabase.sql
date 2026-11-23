-- Run this in Supabase → SQL Editor → New query → Run.
-- Safe to run in an existing project: it only creates one new table.

create table if not exists public.contact_messages (
  id         bigint generated always as identity primary key,
  name       text not null check (char_length(name) between 1 and 100),
  email      text not null check (char_length(email) between 3 and 200),
  message    text not null check (char_length(message) between 1 and 2000),
  created_at timestamptz not null default now()
);

alter table public.contact_messages enable row level security;

-- Visitors (anon key) may INSERT only. No select/update/delete policy = they cannot read or change anything.
drop policy if exists "anon can insert messages" on public.contact_messages;
create policy "anon can insert messages"
  on public.contact_messages
  for insert
  to anon
  with check (true);

-- New Supabase projects don't auto-grant table access to API roles, so grant INSERT only.
grant insert on public.contact_messages to anon;

-- You read the messages in Supabase → Table Editor (the dashboard bypasses RLS).
