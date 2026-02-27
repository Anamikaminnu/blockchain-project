# Firebase Database Secret - Quick Setup Guide

## What is a Database Secret?

A Firebase Database Secret is a credential that grants full access to your Firebase Realtime Database. It's used for **server-side access only** and should never be exposed publicly.

## How to Get Your Database Secret

### For Firebase Realtime Database (Legacy - if available):

1. Go to: **https://console.firebase.google.com**
2. Select your project: **accidentdetection-a3f5c**
3. Go to **⚙️ Project Settings** (gear icon, top right)
4. Click **📋 Secrets** tab
5. Look for your database secret (or REST API secret)
6. Copy it

### For Modern Firebase Setup (Recommended):

If database secrets aren't available, use **Service Account keys**:

1. Go to: **https://console.firebase.google.com**
2. Select project: **accidentdetection-a3f5c**
3. **Project Settings** → **Service Accounts**
4. Click **Generate New Private Key**
5. A JSON file downloads - this contains your credentials

## How to Use the Database Secret

### Option A: Set as Environment Variable (Recommended)

**On Windows:**

1. Create a `.env` file in your project root:
   ```
   FIREBASE_DATABASE_SECRET=your_secret_here
   ```

2. Django will automatically read it from settings.py

**On Linux/Mac:**

```bash
export FIREBASE_DATABASE_SECRET="your_secret_here"
python manage.py runserver
```

### Option B: Set in Django Settings

Edit `accident_detection/settings.py`:

```python
FIREBASE_DATABASE_SECRET = 'your_secret_here'  # Replace with actual secret
```

⚠️ **WARNING**: Never commit secrets to version control! Use environment variables instead.

## Verify It Works

After setting the database secret, run:

```bash
python manage.py test_firebase
```

You should see:
```
✅ Database secret authentication successful!
```

## Security Best Practices

✅ **DO:**
- Use environment variables for secrets
- Keep secrets out of version control
- Add `.env` to `.gitignore`
- Rotate secrets regularly
- Use database secrets only for backend access

❌ **DON'T:**
- Hardcode secrets in Python files
- Share secrets in emails or chat
- Commit secrets to Git
- Use secrets in client-side code
- Display secrets in logs/error messages

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Secret not working | Verify you copied it correctly |
| Still getting 401 | May be old/revoked secret - generate new one |
| Can't find secret | Check if your Firebase project has Realtime Database enabled |
| Multiple secrets | Use the one specifically for REST API or Realtime Database |

## Alternative: Use Public Read Rules (Development Only)

If you can't get/use a database secret, temporarily allow public read:

1. Firebase Console → Realtime Database → **Rules**
2. Paste:
   ```json
   {
     "rules": {
       ".read": true,
       ".write": false
     }
   }
   ```
3. Click **Publish**

⚠️ This makes your database publicly readable. Use only for development!

## Production Configuration

For production, use **custom security rules** with proper authentication:

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth.uid === 'your_authorized_device_id'"
  }
}
```

This requires setting up Firebase Authentication properly.

## Questions?

- See: `FIREBASE_AUTH_OPTIONS.py` (complete setup options)
- See: `QUICK_START.md` (quick reference)
- Firebase Docs: https://firebase.google.com/docs/database/rest/start

---

**Quick Action:**
1. Get your database secret from Firebase Console
2. Add to `.env` file: `FIREBASE_DATABASE_SECRET=your_secret`
3. Run: `python manage.py test_firebase`
4. If successful, vehicle tracking will work! 🚀
