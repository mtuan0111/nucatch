# Quick Setup: Update Store URLs

## Required Changes

Before deploying the app update notification system, you **MUST** update the store URLs in the `.env` file.

### File to Update

`.env` (in the root directory)

### Add These Lines

```dotenv
# App Store Configuration
ANDROID_PACKAGE_NAME=com.example.nucatch
IOS_APP_ID=1234567890
```

## How to Update

### 1. Find Your Android Package Name

Your package name is in `android/app/build.gradle`:

```gradle
android {
    namespace "com.example.nucatch"  // This is your package name
    ...
}
```

Or check `AndroidManifest.xml`:

```xml
<manifest xmlns:android="..."
    package="com.example.nucatch">  <!-- This is your package name -->
```

### 2. Find Your iOS App ID

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Select your app
3. Go to **App Information**
4. Find **Apple ID** (e.g., `1234567890`)

### 3. Update the Code

Replace the values in `.env`:

```dotenv
# App Store Configuration
ANDROID_PACKAGE_NAME=com.example.nucatch
IOS_APP_ID=1234567890
```

With your actual values:

```dotenv
# App Store Configuration
ANDROID_PACKAGE_NAME=com.nucatch.app
IOS_APP_ID=6738291045
```

## Testing the URLs

### Test Android URL

Open in browser:
```
https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME
```

Should redirect to your app's Play Store page.

### Test iOS URL

Open in browser:
```
https://apps.apple.com/app/idYOUR_APP_ID
```

Should redirect to your app's App Store page.

## Checklist

- [ ] Updated ANDROID_PACKAGE_NAME in `.env`
- [ ] Updated IOS_APP_ID in `.env`
- [ ] Tested Android URL in browser
- [ ] Tested iOS URL in browser
- [ ] Committed changes to version control

## Example (NuCatch App)

Assuming:
- Android package: `com.nucatch.app`
- iOS App ID: `6738291045`

Updated `.env`:

```dotenv
# App Store Configuration
ANDROID_PACKAGE_NAME=com.nucatch.app
IOS_APP_ID=6738291045
```

---

**Important**: 
- The `.env` file is loaded automatically by flutter_dotenv in `main.dart`
- Values are read at runtime using `dotenv.env['KEY_NAME']`
- Without updating these values, the "Update Now" button will use placeholder URLs!
