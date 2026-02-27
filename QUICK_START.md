# Quick Start Guide - Vehicle Tracking

## What Was Implemented

A complete vehicle tracking system that fetches real-time location and impact data from Firebase and displays it in an interactive dashboard.

## Current Status

✅ Views created  
✅ API endpoints ready  
✅ Templates designed  
✅ Error handling implemented  
⏳ **Awaiting Firebase Rule Configuration**

## The Issue

Firebase returned: `401 Unauthorized - Permission denied`

**Why?** Firebase security rules block public access by default.

## The Fix (2 minutes)

### Step 1: Open Firebase Console
👉 https://console.firebase.google.com/project/accidentdetection-a3f5c/database/rules

### Step 2: Copy Security Rules
```json
{
  "rules": {
    ".read": true,
    ".write": false
  }
}
```

### Step 3: Paste & Publish
- Paste rules in the editor
- Click **Publish**
- Wait for green checkmark

### Step 4: Test
Run in terminal:
```bash
python manage.py test_firebase
```

Expected output: ✅ Success

## Access Your Vehicle Tracker

**Option 1: Web Dashboard**
```
http://localhost:8000/vehicle-tracking/
```
Features:
- Impact status indicator
- Device status
- GPS coordinates
- Embedded Google Map
- Alert notifications

**Option 2: API (JSON)**
```
http://localhost:8000/api/vehicle-status/
```
Response:
```json
{
  "status": "success",
  "data": {
    "impact_status": "Safe",
    "device_status": "Safe",
    "latitude": 0.0,
    "longitude": 0.0,
    "alert": false
  }
}
```

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `myapp/views.py` | ✏️ Modified | Enhanced Firebase functions |
| `accident_detection/settings.py` | ✏️ Modified | Added Firebase config |
| `templates/vehicle_live_status.html` | ✏️ Modified | Better error UI |
| `FIREBASE_SETUP.md` | 📄 New | Setup documentation |
| `FIREBASE_FIX_SUMMARY.md` | 📄 New | Changes summary |
| `myapp/management/commands/test_firebase.py` | 📄 New | Diagnostic tool |
| `.env.example` | 📄 New | Configuration template |

## Management Commands

```bash
# Test Firebase connection
python manage.py test_firebase

# Run server
python manage.py runserver

# Create superuser (first time setup)
python manage.py createsuperuser
```

## Data Flow

```
Your IoT Device / Vehicle
    ↓
    Sends data to Firebase
    ↓
Django App (this app)
    ↓
    Fetches from Firebase REST API
    ↓
Displays on:
├── Web Dashboard (/vehicle-tracking/)
└── JSON API (/api/vehicle-status/)
```

## Sample Vehicle Data Format

Your Firebase should have this structure:
```json
{
  "Device": "Safe",
  "Impact": "Safe",
  "LOC_IMPACT": "Safe_https://maps.google.com/?q=28.7041,77.1025",
  "LOC_MPU6050": "Safe_https://maps.google.com/?q=28.7041,77.1025",
  "MPU6050": "Safe"
}
```

## Status Indicators

| Status | Meaning | Color |
|--------|---------|-------|
| Safe | No issues detected | 🟢 Green |
| Alert | Impact or issue found | 🔴 Red |
| Unknown | Data not available | ⚪ Gray |

## Troubleshooting

### Still Getting 401 Error?
1. Verify Firebase project ID: `accidentdetection-a3f5c`
2. Check Rules tab shows your rules
3. Wait 30 seconds after publishing
4. Run `python manage.py test_firebase` again

### No Data Showing?
1. Check data exists in Firebase Realtime Database
2. Verify data structure matches expected format
3. Check browser console for errors (F12)
4. Run Django server with: `python manage.py runserver --verbosity 2`

### Map Not Loading?
- Ensure valid GPS coordinates in `LOC_IMPACT` URL
- Format must be: `https://maps.google.com/?q=LATITUDE,LONGITUDE`

## Production Security

⚠️ Before deploying to production:

1. **Configure Proper Security Rules**
   ```json
   {
     "rules": {
       ".read": false,
       ".write": false,
       "vehicle": {
         ".read": "auth != null",
         ".write": "root.child('admins').child(auth.uid).val() === true"
       }
     }
   }
   ```

2. **Use Firebase Admin SDK** for backend access

3. **Set DEBUG = False** in settings.py

4. **Review Firebase Documentation**: https://firebase.google.com/docs/database/security

## Next Steps

1. ✅ Configure Firebase rules (see "The Fix" above)
2. ✅ Run `python manage.py test_firebase`
3. ✅ Visit `http://localhost:8000/vehicle-tracking/`
4. ✅ Check live vehicle data

## Support

- **Local Testing**: `python manage.py test_firebase`
- **Error Logs**: Check Django console output
- **Firebase Issues**: See `FIREBASE_SETUP.md`
- **Django Deployment**: https://docs.djangoproject.com/en/5.2/howto/deployment/

---

**Ready to go!** 🚀

Just update Firebase rules and you're all set.
