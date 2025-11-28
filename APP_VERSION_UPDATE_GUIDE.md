# App Version Update Notification System

This document provides comprehensive documentation for the app version update notification system implemented in NuCatch.

## Overview

The app version update notification system checks for new app versions from Cloud Firestore and displays an update dialog to users. It supports both **force updates** (mandatory) and **optional updates** (user can dismiss).

## Architecture

The system follows the **BLoC pattern** and consists of:

1. **Model**: `AppVersionModel` - Firestore data structure
2. **Services**: `AppVersionServices` - Business logic for version checking
3. **BLoC**: `AppVersionBloc` - State management
4. **UI**: `UpdateNoticeDialog` - Update notification popup
5. **Wrapper**: `UpdateCheckerWrapper` - Auto-check on app launch

## Cloud Firestore Schema

### Collection: `app_versions`

Each document in the `app_versions` collection represents a version release for a specific platform.

```json
{
  "platform": "android",           // or "ios"
  "version_name": "1.2.0",         // Display version (e.g., "1.2.0")
  "build_number": "12",            // Build number as string (e.g., "12")
  "release_message": "Bug fixes and performance improvements", // Optional release notes
  "is_force_update": false,        // true = mandatory, false = optional
  "created_at": Timestamp,         // Auto-set on creation
  "updated_at": Timestamp          // Auto-set on update
}
```

### Field Descriptions

- **platform** (string, required): `"android"` or `"ios"` - identifies the target platform
- **version_name** (string, required): Human-readable version (e.g., "1.2.0", "2.0.0-beta")
- **build_number** (string, required): Integer as string for version comparison (e.g., "12", "15")
- **release_message** (string, optional): What's new in this release, shown in the dialog
- **is_force_update** (bool, required): If `true`, users cannot dismiss the update dialog
- **created_at** (timestamp): Document creation time
- **updated_at** (timestamp): Last update time

### Firestore Rules Example

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /app_versions/{version} {
      // Allow everyone to read app versions
      allow read: if true;
      
      // Only authenticated admins can write
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
  }
}
```

## Version Comparison Logic

The system compares versions using the **build_number** field as an integer:

1. Fetches all versions for the current platform from Firestore
2. Orders by `build_number` descending
3. Checks for versions with `is_force_update = true` first
4. If force update exists and is newer, returns it immediately
5. Otherwise, returns the latest version if newer than current

### Example Comparison

```
Current app: build_number = "10"
Firestore versions:
  - build_number = "15", is_force_update = false
  - build_number = "12", is_force_update = true
  - build_number = "8", is_force_update = false

Result: Returns build_number "12" (force update takes priority over newer non-force updates)
```

## BLoC Events

### CheckForUpdateEvent

Triggers a version check from Firestore.

```dart
context.read<AppVersionBloc>().add(CheckForUpdateEvent());
```

### DismissUpdateEvent

Dismisses the update dialog (only allowed if `is_force_update = false`).

```dart
context.read<AppVersionBloc>().add(DismissUpdateEvent());
```

### UpdateLaterEvent

User chooses to update later (only for optional updates).

```dart
context.read<AppVersionBloc>().add(UpdateLaterEvent());
```

## BLoC States

### AppVersionStatus Enum

```dart
enum AppVersionStatus {
  initial,          // Initial state, no check performed
  checking,         // Checking for updates from Firestore
  updateAvailable,  // Update found and should be shown
  noUpdate,         // App is up to date
  error,            // Error occurred during check
  dismissed,        // User dismissed the optional update
}
```

### AppVersionState Properties

```dart
class AppVersionState {
  final AppVersionStatus status;
  final AppVersionModel? availableVersion;  // New version info from Firestore
  final String? currentVersion;             // Current app version (e.g., "1.0.0")
  final String? currentBuildNumber;         // Current build number (e.g., "10")
  final String? errorMessage;               // Error message if status is error
  final bool isForceUpdate;                 // Whether update is mandatory
}
```

### Helper Getters

- **shouldShowUpdateDialog**: `true` if status is `updateAvailable` and not dismissed
- **isDismissed**: `true` if user dismissed the update
- **canDismiss**: `true` if update is optional (`isForceUpdate = false`)

## UI Components

### UpdateNoticeDialog

Displays the update notification with version information.

**Features:**
- Shows current vs. new version
- Displays release notes if available
- Force update: red/orange theme, no dismiss button, blocks back button
- Optional update: blue theme, "Later" button available

**Props:**
```dart
UpdateNoticeDialog(
  versionInfo: AppVersionModel,      // New version from Firestore
  currentVersion: String,            // Current app version
  isForceUpdate: bool,               // Mandatory update?
  onUpdateLater: VoidCallback?,      // Called when "Later" tapped
  onDismiss: VoidCallback?,          // Called when dismissed
)
```

### UpdateCheckerWrapper

Automatically checks for updates when the app launches.

**Usage:**
```dart
UpdateCheckerWrapper(
  child: YourAppContent(),
)
```

**How it works:**
1. Wraps your app content
2. Triggers `CheckForUpdateEvent` after first frame
3. Listens for `updateAvailable` state
4. Automatically shows `UpdateNoticeDialog` when update detected

## Integration

### 1. Add to BLoC Providers

In `main.dart`:

```dart
MultiBlocProvider(
  providers: [
    // ... other providers
    BlocProvider(
      create: (context) => AppVersionBloc(),
    ),
  ],
  child: YourApp(),
)
```

### 2. Wrap App Content

Wrap your main navigation with `UpdateCheckerWrapper`:

```dart
UpdateCheckerWrapper(
  child: MenuNav(),  // or your root widget
)
```

### 3. Configure Store URLs

In `update_notice_dialog.dart`, update the store URLs with your actual app links:

```dart
String get _storeUrl {
  if (Platform.isAndroid) {
    return 'https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME';
  } else if (Platform.isIOS) {
    return 'https://apps.apple.com/app/idYOUR_APP_ID';
  }
  return '';
}
```

## Usage Examples

### Example 1: Add a New Android Version (Optional Update)

In Firebase Console > Firestore > `app_versions` collection:

```json
{
  "platform": "android",
  "version_name": "1.3.0",
  "build_number": "13",
  "release_message": "• New game modes\n• Bug fixes\n• Performance improvements",
  "is_force_update": false,
  "created_at": <auto>,
  "updated_at": <auto>
}
```

Result: Users with build number < 13 will see an optional update dialog.

### Example 2: Force Update for Critical Bug Fix

```json
{
  "platform": "android",
  "version_name": "1.2.1",
  "build_number": "11",
  "release_message": "Critical security update. Please update immediately.",
  "is_force_update": true,
  "created_at": <auto>,
  "updated_at": <auto>
}
```

Result: Users cannot dismiss the dialog and must update to continue.

### Example 3: iOS Beta Release

```json
{
  "platform": "ios",
  "version_name": "2.0.0-beta",
  "build_number": "20",
  "release_message": "Beta version with new features. Try it out!",
  "is_force_update": false,
  "created_at": <auto>,
  "updated_at": <auto>
}
```

Result: Only iOS users see this update.

### Example 4: Manual Check for Updates

Trigger a version check from anywhere in the app:

```dart
ElevatedButton(
  onPressed: () {
    context.read<AppVersionBloc>().add(CheckForUpdateEvent());
  },
  child: Text('Check for Updates'),
)
```

### Example 5: Listen to Update Status

```dart
BlocBuilder<AppVersionBloc, AppVersionState>(
  builder: (context, state) {
    if (state.status == AppVersionStatus.checking) {
      return CircularProgressIndicator();
    }
    if (state.status == AppVersionStatus.updateAvailable) {
      return Text('Update available: ${state.availableVersion?.versionName}');
    }
    return Text('App is up to date');
  },
)
```

## Testing

### Test Force Update

1. Set current app build number to "10"
2. Add Firestore document:
   ```json
   {
     "platform": "android",
     "build_number": "15",
     "is_force_update": true,
     "version_name": "1.5.0"
   }
   ```
3. Launch app
4. Verify: Dialog appears, cannot be dismissed, back button doesn't close it

### Test Optional Update

1. Set current app build number to "10"
2. Add Firestore document:
   ```json
   {
     "platform": "android",
     "build_number": "12",
     "is_force_update": false,
     "version_name": "1.2.0",
     "release_message": "Optional update with new features"
   }
   ```
3. Launch app
4. Verify: Dialog appears, "Later" button visible, can dismiss with back button

### Test No Update

1. Set current app build number to "15"
2. Add Firestore document:
   ```json
   {
     "platform": "android",
     "build_number": "10",
     "version_name": "1.0.0"
   }
   ```
3. Launch app
4. Verify: No dialog appears, app proceeds normally

## Troubleshooting

### Dialog Not Appearing

1. Check Firestore collection exists: `app_versions`
2. Verify platform field matches: `"android"` or `"ios"`
3. Check build_number comparison: new > current
4. Ensure `AppVersionBloc` is in provider tree
5. Confirm `UpdateCheckerWrapper` wraps your app

### Wrong Platform Showing

- Verify platform detection in `AppVersionServices.getPlatform()`
- Check Firestore documents have correct `platform` field

### Update Dialog Appears Every Launch

- This is expected behavior if update exists and user hasn't updated
- User must install the new version from the store to stop seeing it

### Force Update Can Be Dismissed

- Check `is_force_update` field is boolean `true`, not string `"true"`
- Verify `WillPopScope` in `UpdateNoticeDialog` blocks back button

## Best Practices

1. **Version Numbering**: Use incremental integers for build_number (1, 2, 3...)
2. **Release Messages**: Keep concise, use bullet points for multiple changes
3. **Force Updates**: Use sparingly, only for critical security/compatibility issues
4. **Testing**: Always test in staging environment before production
5. **Rollback Plan**: Keep previous versions available in case of issues
6. **Platform Separation**: Maintain separate version tracks for Android and iOS

## Security Considerations

1. **Firestore Rules**: Restrict write access to admin users only
2. **URL Validation**: Ensure store URLs point to official app stores only
3. **Version Verification**: Server-side validation recommended for critical apps
4. **Rate Limiting**: Consider implementing client-side rate limiting for version checks

## Dependencies

- `package_info_plus`: ^8.1.2 - Get current app version
- `url_launcher`: ^6.3.1 - Open store URLs
- `cloud_firestore`: (via Firebase) - Version data storage
- `flutter_bloc`: ^8.x.x - State management

## Future Enhancements

- [ ] Add in-app update for Android (Google Play Core)
- [ ] Implement A/B testing for updates
- [ ] Add analytics tracking for update events
- [ ] Support for staged rollouts
- [ ] Local caching to reduce Firestore reads
- [ ] Customizable update check intervals

## Support

For issues or questions:
- Check Firestore console for version documents
- Review Flutter logs for errors
- Verify BLoC state changes with BLoC observer
- Test with Firebase emulator for local development

---

**Version**: 1.0.0  
**Last Updated**: 2024  
**Author**: NuCatch Development Team
