# Firebase Real-time Database Configuration

## Current Issue
Firebase Realtime Database requires **security rules** to allow data access. Simply having the API key is not sufficient.

### Error: `401 Unauthorized - Permission denied`
This occurs when Firebase security rules don't permit the read access you're attempting.

---

## Solution Options

### Option 1: Configure Firebase Security Rules (Recommended for Production)

1. **Go to Firebase Console:**
   - Navigate to: https://console.firebase.google.com
   - Select your project: `accidentdetection-a3f5c`
   - Go to: **Realtime Database** → **Rules**

2. **Set Security Rules** to allow public read access (for development):
   ```json
   {
     "rules": {
       ".read": true,
       ".write": false
     }
   }
   ```

3. **For Production Security**, use more restrictive rules:
   ```json
   {
     "rules": {
       ".read": false,
       ".write": false,
       "vehicle": {
         ".read": "auth != null",
         ".write": "auth.uid !== null"
       }
     }
   }
   ```

### Option 2: Use Firebase Database Secret (Server-Side Only)

For backend access, use your database secret instead of API key:

1. **Get Database Secret:**
   - Firebase Console → Project Settings → Service Accounts
   - Generate new private key
   - Extract the `database_secret` parameter

2. **Update Django Settings** (`accident_detection/settings.py`):
   ```python
   FIREBASE_DATABASE_SECRET = 'YOUR_DATABASE_SECRET_HERE'
   ```

3. **Update the fetch function** in `myapp/views.py`:
   ```python
   # Use .auth=YOUR_SECRET in URL instead of API key
   url = f"{firebase_url}/.json?auth={database_secret}"
   ```

### Option 3: Use Firebase REST API with Service Account (Most Secure)

1. **Download Service Account Key:**
   - Firebase Console → Project Settings → Service Accounts → Generate new private key
   - Save as `firebase-key.json`

2. **Install Additional Package:**
   ```bash
   pip install firebase-admin
   ```

3. **Update Django Settings:**
   ```python
   import firebase_admin
   from firebase_admin import credentials, db
   
   # Initialize Firebase
   cred = credentials.Certificate('path/to/firebase-key.json')
   firebase_admin.initialize_app(cred, {
       'databaseURL': 'https://accidentdetection-a3f5c-default-rtdb.firebaseio.com'
   })
   ```

---

## Current Configuration

**File:** `accident_detection/settings.py`

```python
FIREBASE_DATABASE_URL = 'https://accidentdetection-a3f5c-default-rtdb.firebaseio.com'
FIREBASE_API_KEY = 'AIzaSyC7O1wYVQn_RaOU9vzk9FFzrErPdrhCoYA'
```

**Views Using Firebase:**
- `vehicle_live_status()` - Displays vehicle tracking page
- `vehicle_live_status_api()` - Returns JSON data

---

## Quick Fix for Development

To enable the vehicle tracking immediately, go to:

**Firebase Console** → **Realtime Database** → **Rules**

And apply:
```json
{
  "rules": {
    ".read": true,
    ".write": false
  }
}
```

⚠️ **WARNING**: This makes your database publicly readable. Only use for development/testing!

---

## Testing the Connection

### Test Script
```python
import requests

firebase_url = 'https://accidentdetection-a3f5c-default-rtdb.firebaseio.com'
api_key = 'AIzaSyC7O1wYVQn_RaOU9vzk9FFzrErPdrhCoYA'

# Try with API key
url = f"{firebase_url}/.json?key={api_key}"
response = requests.get(url)
print(f"Status: {response.status_code}")
print(f"Data: {response.json()}")
```

### Django Shell Test
```bash
python manage.py shell
```

```python
from myapp.views import fetch_firebase_vehicle_data
data = fetch_firebase_vehicle_data('https://accidentdetection-a3f5c-default-rtdb.firebaseio.com', 'YOUR_API_KEY')
print(data)
```

---

## Expected Data Structure

Your Firebase should have this structure:

```
{
  "Device": "Safe",
  "Impact": "Safe",
  "LOC_IMPACT": "Safe_https://maps.google.com/?q=0.000000,0.000000",
  "LOC_MPU6050": "Safe_https://maps.google.com/?q=0.000000,0.000000",
  "MPU6050": "Safe"
}
```

---

## Useful Links

- [Firebase Security Rules Documentation](https://firebase.google.com/docs/database/security)
- [Firebase REST API Guide](https://firebase.google.com/docs/database/rest/start)
- [Firebase Authentication Methods](https://firebase.google.com/docs/auth)
- [Django Deployment Security Checklist](https://docs.djangoproject.com/en/5.2/howto/deployment/checklist/)

---

## Need Help?

If you're still getting errors:

1. Check Firebase Console for security rules
2. Verify the database URL is correct
3. Ensure your data structure matches the expected format
4. Check browser console for CORS issues
5. Review Django logs for detailed error messages
