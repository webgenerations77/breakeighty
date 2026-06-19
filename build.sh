#!/bin/bash
# Replace placeholder tokens in index.html with Vercel environment variables

sed -i "s|__FIREBASE_API_KEY__|${FIREBASE_API_KEY}|g" index.html
sed -i "s|__FIREBASE_AUTH_DOMAIN__|${FIREBASE_AUTH_DOMAIN}|g" index.html
sed -i "s|__FIREBASE_PROJECT_ID__|${FIREBASE_PROJECT_ID}|g" index.html
sed -i "s|__FIREBASE_STORAGE_BUCKET__|${FIREBASE_STORAGE_BUCKET}|g" index.html
sed -i "s|__FIREBASE_MESSAGING_SENDER_ID__|${FIREBASE_MESSAGING_SENDER_ID}|g" index.html
sed -i "s|__FIREBASE_APP_ID__|${FIREBASE_APP_ID}|g" index.html
sed -i "s|__DREW_EMAIL__|${DREW_EMAIL}|g" index.html
sed -i "s|__STEVE_EMAIL__|${STEVE_EMAIL}|g" index.html
sed -i "s|__EMAILJS_SERVICE_ID__|${EMAILJS_SERVICE_ID}|g" index.html
sed -i "s|__EMAILJS_TEMPLATE_ID__|${EMAILJS_TEMPLATE_ID}|g" index.html
sed -i "s|__EMAILJS_PUBLIC_KEY__|${EMAILJS_PUBLIC_KEY}|g" index.html
sed -i "s|__EMAILJS_NOTIF_EMAIL__|${EMAILJS_NOTIF_EMAIL}|g" index.html

# Also replace in firestore.rules if present
if [ -f firestore.rules ]; then
  sed -i "s|__DREW_EMAIL__|${DREW_EMAIL}|g" firestore.rules
  sed -i "s|__STEVE_EMAIL__|${STEVE_EMAIL}|g" firestore.rules
fi
