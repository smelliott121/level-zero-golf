-- Level Zero Golf: accounts, saved progress, rounds and the leaderboard.
-- Paste this whole file into Supabase → SQL Editor → New query → Run.

-- one row per player: their public name and a copy of their progress (so it follows them between phones)
create table if not exists public.players (
  id          uuid primary key references auth.users on delete cascade,
  nick        text not null check (char_length(nick) between 1 and 16),
  level       int  not null default 0,
  handicap    numeric(4,1),
  rounds      int  not null default 0,
  brand       text,
  save        jsonb,
  updated_at  timestamptz not null default now()
);

-- every completed nine-hole round
create table if not exists public.rounds (
  id          bigint generated always as identity primary key,
  player_id   uuid not null default auth.uid() references auth.users on delete cascade,
  course      text not null check (course in ('links','bay')),
  scores      int[] not null check (array_length(scores,1) = 9),
  gross       int  not null,
  to_par      int  not null,
  stableford  int,
  handicap    numeric(4,1),
  played_at   timestamptz not null default now()
);
create index if not exists rounds_course_gross on public.rounds (course, gross);
create index if not exists rounds_player_day  on public.rounds (player_id, played_at);

-- server-side rules for a round: 18 holes (two rounds) a day, sane scores, gross worked out from the card
create or replace function public.check_round() returns trigger
language plpgsql security definer set search_path = public as $$
declare
  par_total int := case new.course when 'links' then 35 when 'bay' then 33 end;
begin
  if (select count(*) from public.rounds
        where player_id = new.player_id
          and (played_at at time zone 'Europe/London')::date = (now() at time zone 'Europe/London')::date) >= 2 then
    raise exception 'Only 18 holes a day';
  end if;
  if exists (select 1 from unnest(new.scores) s where s < 1 or s > 15) then
    raise exception 'Hole scores must be between 1 and 15';
  end if;
  new.gross     := (select sum(s) from unnest(new.scores) s);
  new.to_par    := new.gross - par_total;
  new.played_at := now();
  return new;
end $$;

create trigger rounds_check before insert on public.rounds
  for each row execute function public.check_round();
-- the trigger runs on its own; nobody needs to call it directly
revoke execute on function public.check_round() from public, anon, authenticated;

-- row level security: everyone can read the board, players can only write their own rows
alter table public.players enable row level security;
alter table public.rounds  enable row level security;

drop policy if exists "players are public"        on public.players;
drop policy if exists "players insert own"        on public.players;
drop policy if exists "players update own"        on public.players;
drop policy if exists "rounds are public"         on public.rounds;
drop policy if exists "rounds insert own"         on public.rounds;

create policy "players are public" on public.players for select using (true);
create policy "players insert own" on public.players for insert with check ((select auth.uid()) = id);
create policy "players update own" on public.players for update using ((select auth.uid()) = id) with check ((select auth.uid()) = id);
create policy "rounds are public"  on public.rounds  for select using (true);
create policy "rounds insert own"  on public.rounds  for insert with check ((select auth.uid()) = player_id);
-- no update or delete policies on rounds: a posted card is final

-- best round per player per course, with their current name, handicap and level
create or replace view public.leaderboard with (security_invoker = on) as
select distinct on (r.course, r.player_id)
  r.course, r.player_id, p.nick, p.handicap, p.level, p.brand, p.rounds,
  r.gross, r.to_par, r.stableford, r.played_at
from public.rounds r
join public.players p on p.id = r.player_id
order by r.course, r.player_id, r.gross asc, r.played_at asc;

grant select on public.leaderboard to anon, authenticated;
