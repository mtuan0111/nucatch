# Quick Start: App Update Notifications

Get the app update notification system up and running in 5 minutes!

## Step 1: Update Store URLs (1 minute)

Edit `.env` file in your project root:

```dotenv
# App Store Configuration
ANDROID_PACKAGE_NAME=com.example.nucatch
IOS_APP_ID=1234567890
```

Replace with your actual values:

```dotenv
# App Store Configuration
ANDROID_PACKAGE_NAME=com.nucatch.app
IOS_APP_ID=6738291045
```

**Find your package name**: `android/app/build.gradle` → `namespace`  
**Find your App ID**: [App Store Connect](https://appstoreconnect.apple.com/) → App Information → Apple ID

## Step 2: Setup Firestore (2 minutes)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Firestore Database**
4. Create collection: `app_versions`
5. Add your first version document:

```json
{
  "platform": "android",
  "version_name": "1.0.1",
  "build_number": "2",
  "release_message": "Bug fixes and improvements",
  "is_force_update": false
}
```

## Step 3: Test It! (1 minute)

1. Make sure your current app version is older than the one in Firestore
2. Run your app: `flutter run`
3. Update dialog should appear automatically!

## Firestore Rules (Optional but Recommended)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /app_versions/{version} {
      allow read: if true;
      allow write: if request.auth != null; // Only authenticated users
    }
  }
}
```

## Common Use Cases

### Show Optional Update
```json
{
  "platform": "android",
  "version_name": "1.2.0",
  "build_number": "12",
  "release_message": "New features available!",
  "is_force_update": false
}
```
✅ User can dismiss or postpone

### Require Update (Force Update)
```json
{
  "platform": "android",
  "version_name": "1.1.0",
  "build_number": "11",
  "release_message": "Critical security update",
  "is_force_update": true
}
```
⚠️ User MUST update to continue

### iOS Version
```json
{
  "platform": "ios",
  "version_name": "1.3.0",
  "build_number": "13",
  "release_message": "iOS optimizations",
  "is_force_update": false
}
```
🍎 Only iOS users see this

## That's It!

Your app now has a professional update notification system! 🎉

### What Happens Now?

- ✅ App checks for updates on launch
- ✅ Users see update dialog if new version exists
- ✅ "Update Now" button opens App Store/Play Store
- ✅ Optional updates can be dismissed
- ✅ Force updates block the app until updated

## Need More Help?

- 📖 Full guide: `APP_VERSION_UPDATE_GUIDE.md`
- 📝 Implementation details: `APP_VERSION_UPDATE_SUMMARY.md`
- 🔧 URL setup: `UPDATE_STORE_URLS.md`

## Pro Tips

💡 **Build Number**: Always increment this as an integer (1, 2, 3, 4...)  
💡 **Version Name**: Can be anything (1.0.0, 2.0.0-beta, etc.)  
💡 **Force Updates**: Use sparingly! Only for critical fixes  
💡 **Release Message**: Keep it short and clear  
💡 **Testing**: Test both platforms separately (Android vs iOS)

---

**Happy Updating! 🚀**
