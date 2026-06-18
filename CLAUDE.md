# Break 80 — CLAUDE.md

## What this is

Single-page golf tracking app for Drew's "Break 80" challenge. One giant `index.html` (~3800 lines) with inline CSS, HTML, and JS. No framework, no bundler, no npm.

## Architecture

- **Single file**: `index.html` contains everything — styles, markup, and all application logic
- **Backend**: Firebase (Auth + Firestore) loaded via CDN ESM imports
- **Hosting**: Vercel — `build.sh` does token replacement of `__PLACEHOLDER__` env vars at deploy time
- **Config**: `vercel.json` sets build command to `bash build.sh`, output dir `.`
- **Security rules**: `firestore.rules` — deployed manually via Firebase console

## Users / Roles

Three roles, each sees different UI:
- **Drew** (`drew`): Full app — scorecard, live round entry, overview, drills, progress, pledges, messages, AI coach
- **Steve** (`steve`): Coach mode — coach board, homework, live round viewer
- **Guest** (`guest`): Guest mode — live round viewer, messaging, voting, pledging, roast wheel

Role is determined by Google sign-in email (Drew/Steve) or anonymous auth (Guest). CSS classes `guest-mode` and `coach-mode` on `<body>` control nav/header visibility.

## Key Firestore Collections

- `rounds` — Drew's golf rounds (public read, Drew write)
- `guestMessages` — messages, votes, pledges, roasts from guests (public read/create, Drew update/delete)
- `coachNotes` — Steve's coaching notes (Drew + Steve only)
- `hwItems` — homework items (Drew + Steve only)
- `liveRound` — single doc `current` with active round state (public read, Drew write)
- `pledgeContacts` — private pledge contact info (Drew only)

## Build & Deploy

No install step. Build is just `bash build.sh` which runs `sed` to replace placeholder tokens (`__FIREBASE_API_KEY__`, `__DREW_EMAIL__`, etc.) with Vercel env vars. Push to GitHub triggers Vercel auto-deploy.

## Environment Variables

Set in Vercel dashboard (see `FIREBASE_SETUP.md` for full list):
- `FIREBASE_API_KEY`, `FIREBASE_AUTH_DOMAIN`, `FIREBASE_PROJECT_ID`, `FIREBASE_STORAGE_BUCKET`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_APP_ID`
- `DREW_EMAIL`, `STEVE_EMAIL`

## Code Organization (inside index.html)

The file is structured roughly as:
1. `<style>` — all CSS (~400 lines)
2. Firebase module `<script type="module">` — imports, init, auth state listener
3. HTML sections — splash screen, nav, each `<div class="sec">` tab
4. `<script>` — all application JS (~2000+ lines)

### Navigation

SPA-style with `history.pushState`. Each section is a `<div class="sec">`, toggled via `.active` class. `navPush(sec, scView, hole)` drives navigation. `applyNavState()` handles popstate.

### Live Round System

Drew enters scores hole-by-hole. State is stored in `lvScores`, `lvPutts`, `lvFairways`, `lvGIRs` arrays. On each change, `persistLiveRound()` saves to both localStorage and Firestore (`liveRound/current`). Guest and coach views subscribe via `onSnapshot` for real-time updates.

## Conventions

- No external JS dependencies beyond Firebase CDN
- All DOM manipulation is vanilla JS — `document.getElementById`, `innerHTML`, etc.
- Helper pattern: `set(id, value)` to safely set text content
- Inline styles are used heavily in HTML; CSS classes for reusable patterns
- Commit messages are short, descriptive sentences
