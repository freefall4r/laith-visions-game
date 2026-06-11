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

## Turn on the LIVE global leaderboard (Firebase, free, ~3 minutes)
Using **Firebase** (Google) — its free tier never sleeps, so the leaderboard
keeps working even during quiet weeks.

1. Go to **console.firebase.google.com** → **Add project** (free, no card).
2. In the project: **Build → Firestore Database → Create database** →
   start in **production mode** → pick a location (e.g. europe-west).
3. **Rules** tab → replace everything with this → **Publish**:
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /scores/{doc} {
         allow read: if true;
         allow create: if request.resource.data.score is int
                       && request.resource.data.score >= 0
                       && request.resource.data.score < 1000000
                       && request.resource.data.name is string
                       && request.resource.data.name.size() <= 16;
         allow update, delete: if false;
       }
     }
   }
   ```
4. Get the web config: **Project settings (gear) → General →** scroll to
   "Your apps" → click the **</>** (Web) icon → register an app → copy the
   `firebaseConfig` values.
5. Paste `apiKey`, `authDomain`, `projectId`, `appId` into the `firebase` block
   in `CONFIG` (top of `index.html`).
6. Redeploy: run `./deploy.sh` (or `git add -A && git commit -m update && git push`).

These keys are safe to be public. The rules let anyone read and submit a score
(but not edit/delete), and reject malformed entries. The monthly reset is
automatic — the game only shows the current month, tagged on each score.
To remove a cheater, delete that row in the Firestore console.

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
