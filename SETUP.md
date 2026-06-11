# Capture the Shot — setup guide

A one-page mobile game that markets a photographer. Players try to beat the high
score; the top score at month-end wins a free photo session. To qualify they
share their score to their Instagram story and tag the studio.

Everything you need to change lives in **one place**: the `CONFIG = { ... }`
block at the top of `index.html`.

---

## 1. Play it right now
Double-click `index.html` to open it in a browser. It works immediately — scores
are saved on that one device until you turn on the live leaderboard (step 3).

## 2. Branding
Already set to **Laith Visions** (name, @laith_visions, cinematic gold-on-black,
serif wordmark). To tweak, open `index.html` → `CONFIG` block:

- `accent`, `accent2`, `bg` — colors (swap to Laith's real palette if he has one)
- `logo` — optional. Put a logo image next to `index.html` and write its file
  name here (e.g. `"logo.png"`). Leave `""` to show the serif wordmark instead.
- `prizeRule`, `prizeShort`, `monthLabel` — contest wording for this month.

## 2b. Add Laith's 25 photos (the heart of the game)
Each successful capture "develops" the next of his shots, so players rotate
through his portfolio while they play.

1. Get the **25 originals from Laith** (his own photos — higher quality than
   anything downloadable from Instagram, which is login-locked and compressed).
2. Drop them in the **`photos/`** folder next to `index.html`.
3. Name them exactly `1.jpg`, `2.jpg`, … `25.jpg` (lowercase). Portrait/tall
   shots look best.
4. Refresh — they appear automatically. (PNG instead? set `CONFIG.photoExt` to
   `"png"` and name them `1.png` … `25.png`.)

Until the real files are added, the game uses placeholder "SHOT 01…25" frames so
it's still fully playable.

## 3. Turn on the LIVE global leaderboard (free)
So everyone competes on ONE shared list, you need a tiny free database (Supabase):

1. Go to **supabase.com** → sign up → **New project** (free tier).
2. In the project, open **SQL Editor** and run this:
   ```sql
   create table scores (
     id bigint generated always as identity primary key,
     name text not null,
     score int not null,
     created_at timestamptz default now()
   );
   alter table scores enable row level security;
   create policy "anyone can read"  on scores for select using (true);
   create policy "anyone can add"   on scores for insert with check (true);
   ```
3. Open **Project Settings → API**. Copy the **Project URL** and the **anon
   public** key.
4. Paste them into `CONFIG.supabaseUrl` and `CONFIG.supabaseKey` in `index.html`.

That's it — the leaderboard is now global and live. (The anon key is meant to be
public; it can only read/add scores, nothing else.)

> **Each month:** to reset the contest, either delete old rows in Supabase, or
> create a new `scores` table and update the keys. Update `monthLabel` too.

## 4. Put it online (so it's a real link for the IG bio)
Easiest options:
- **Netlify Drop** — go to app.netlify.com/drop and drag the folder in. Instant
  free link.
- **Vercel** — `vercel` in this folder (same as the Plexus site), or drag-drop.

Then the photographer puts that link in his Instagram bio / story "link" sticker.

---

## How the contest runs
1. Photographer posts a story: "Play my game, beat the high score, win a free
   session 👉 link in bio."
2. People play, share their score card to their story, tag the studio.
3. At month-end the photographer checks the leaderboard + who tagged him, and DMs
   the winner.

**Honest note:** a web page can't force someone to actually post the story — the
tag is the proof. That's normal for these contests and it works fine.
