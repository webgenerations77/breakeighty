# Break 80 — Firebase + Vercel Setup Guide

## 1. Create Firebase Project

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Click **Add project** → name it `break80`
3. Disable Google Analytics (not needed) → **Create project**

### Enable Authentication

1. In the Firebase console, go to **Authentication** → **Sign-in method**
2. Enable **Google** sign-in:
   - Click Google → toggle Enable → set a support email → Save
3. Enable **Anonymous** sign-in:
   - Click Anonymous → toggle Enable → Save

### Create Firestore Database

1. Go to **Firestore Database** → **Create database**
2. Select **production mode** (not test mode)
3. Choose a location close to your users (e.g., `us-east1`)
4. Click **Enable**

### Register Web App

1. Go to **Project Settings** (gear icon) → **General** → scroll to **Your apps**
2. Click the web icon (`</>`) → register as `break80-web`
3. Copy the Firebase config object — you'll need these values:
   - `apiKey`
   - `authDomain`
   - `projectId`
   - `storageBucket`
   - `messagingSenderId`
   - `appId`

### Add Authorized Domains

1. Go to **Authentication** → **Settings** → **Authorized domains**
2. Add:
   - `breakeighty.spinachthecow.com`
   - Your Vercel deployment URL (e.g., `breakeighty.vercel.app`)

---

## 2. Deploy Firestore Security Rules

Copy the contents of `firestore.rules` to the Firestore console:

1. Go to **Firestore Database** → **Rules**
2. Replace the default rules with the contents of `firestore.rules`
3. **Before publishing**, replace `__DREW_EMAIL__` and `__STEVE_EMAIL__` with the actual email addresses
4. Click **Publish**

---

## 3. Set Vercel Environment Variables

1. Go to [vercel.com](https://vercel.com) → your project → **Settings** → **Environment Variables**
2. Add the following variables (all environments: Production, Preview, Development):

```
FIREBASE_API_KEY=         ← from Firebase config
FIREBASE_AUTH_DOMAIN=     ← from Firebase config
FIREBASE_PROJECT_ID=      ← from Firebase config
FIREBASE_STORAGE_BUCKET=  ← from Firebase config
FIREBASE_MESSAGING_SENDER_ID= ← from Firebase config
FIREBASE_APP_ID=          ← from Firebase config
DREW_EMAIL=               ← Drew's Google account email
STEVE_EMAIL=              ← Steve's Google account email
EMAILJS_SERVICE_ID=       ← from EmailJS dashboard (optional)
EMAILJS_TEMPLATE_ID=      ← from EmailJS dashboard (optional)
EMAILJS_PUBLIC_KEY=       ← from EmailJS dashboard (optional)
EMAILJS_NOTIF_EMAIL=      ← Drew's notification email (optional)
```

---

## 4. Deploy to Vercel

1. Push all changes to GitHub (`webgenerations77/breakeighty`)
2. Go to [vercel.com](https://vercel.com) → **Add New** → **Project**
3. Import the `webgenerations77/breakeighty` repository
4. Vercel will auto-detect `vercel.json` settings:
   - Build command: `bash build.sh`
   - Output directory: `.`
   - Install command: (none)
5. Click **Deploy**

### After First Deploy

1. Copy your Vercel deployment URL
2. Add it to Firebase authorized domains (see step 1 above)

---

## 5. Migrate Custom Domain

The existing domain `breakeighty.spinachthecow.com` is on GitHub Pages. To migrate:

1. In Vercel: go to **Project** → **Settings** → **Domains** → add `breakeighty.spinachthecow.com`
2. In GitHub: remove the custom domain from the repo's Pages settings (Settings → Pages → remove custom domain)
3. Update DNS: change the CNAME record for `breakeighty.spinachthecow.com` to point to `cname.vercel-dns.com`
4. Wait for DNS propagation (usually 5–30 minutes)
5. Vercel will auto-provision an SSL certificate

---

## 6. Migrate Data from JSONbin to Firestore

Run the one-time migration tool:

1. Open `migrate-jsonbin-to-firestore.html` in a browser
2. Paste your Firebase config values into the form
3. Paste your JSONbin credentials (IDs and API keys)
4. Click **Start Migration**
5. Watch the progress log — each collection write will be confirmed
6. When you see "Migration complete!", verify the data in the Firestore console

**Important:** Run this migration only once. Running it again will create duplicate documents.

---

## 7. Verify Everything Works

1. Visit your Vercel deployment URL
2. Sign in as Drew with Google — verify rounds, messages, pledges load
3. Sign in as Steve with Google — verify coach board loads
4. Open in an incognito window → Continue as Guest — verify guest view works
5. Check the Firestore console to confirm data is being read/written correctly
