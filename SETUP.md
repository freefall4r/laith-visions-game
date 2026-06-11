# Capture the Shot — Laith Visions

A one-page mobile game that markets Laith Visions. Players capture Laith's photos
as they play; the **highest score each month wins a free photo session**. To
qualify they share their score card to their Instagram story and tag
**@laith_visions**.

**Live link:** https://freefall4r.github.io/laith-visions-game/

Everything you'd change lives in the `CONFIG = { ... }` block at the top of
`index.html`.

---

## Status
- ✅ Built, branded (monochrome editorial), 17 of Laith's photos wired in.
- ✅ Deployed to GitHub Pages (link above). Works on any phone, no install.
- ✅ Leaderboard **auto-resets every month** — only the current month's scores
  count, and the header shows the live month. No manual reset, ever.
- ⏳ ONE step left for a true *global* contest: connect the free database
  (Supabase) below, then redeploy. Until then, scores save per-device.

## Turn on the LIVE global leaderboard (free, ~2 minutes)
So everyone competes on ONE shared monthly list:

1. Go to **supabase.com** → sign up (free) → **New project**.
2. Open **SQL Editor** → **New query** → paste and run:
   ```sql
   create table scores (
     id bigint generated always as identity primary key,
     name text not null,
     score int not null,
     created_at timestamptz default now()
   );
   alter table scores enable row level security;
   create policy "anyone can read" on scores for select using (true);
   create policy "anyone can add"  on scores for insert with check (true);
   ```
3. Open **Project Settings → API**. Copy the **Project URL** and the **anon
   public** key.
4. Paste both into `CONFIG.supabaseUrl` and `CONFIG.supabaseKey` in `index.html`.
5. Redeploy: run `./deploy.sh` (or `git add -A && git commit -m update && git push`).

The anon key is meant to be public — it can only read/add scores, nothing else.
The monthly reset is automatic (the game filters scores to the current month).

## Update the photos or anything else
1. Edit files (drop new photos into `photos/` as `1.jpg`, `2.jpg`, … or change
   `CONFIG`).
2. Run **`./deploy.sh`** — it commits and pushes; the live link updates in ~1 min.

(Photos: portrait/tall `.jpg` look best. For more than 17, just add `18.jpg` …
and bump `CONFIG.photoCount`. The optimizer that shrank Laith's originals is the
`sips` step — keep web copies small, ~1600px.)

---

## How the contest runs each month
1. Laith posts a story: "Play my game, beat the high score, win a free session
   👉 link in bio."
2. People play, share their score card to their story, tag **@laith_visions**.
3. On the 1st, the leaderboard resets. Laith checks the previous month's top
   score + who tagged him, and DMs the winner.

**Honest note:** a web page can't force someone to actually post the story — the
tag is the proof. That's normal for these contests and works fine.
