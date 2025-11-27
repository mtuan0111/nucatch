# Firebase Anonymous Authentication Implementation

## Overview
This project now supports Firebase Anonymous Authentication, allowing users to use the app without creating an account. Each user automatically gets a unique Firebase User ID that persists across app sessions.

## What Was Implemented

### 1. Dependencies Added
- **firebase_auth: ^6.1.1** - Firebase Authentication SDK for Flutter

### 2. New Service: AuthServices
**Location:** `/lib/services/auth_services.dart`

Provides authentication functionality:
- `signInAnonymously()` - Automatically signs in users anonymously
- `signOut()` - Signs out the current user
- `isSignedIn()` - Checks if user is authenticated
- `linkWithCredential()` - Allows upgrading anonymous accounts to permanent accounts (email/phone) in the future
- `deleteAccount()` - Deletes the current user account
- `authStateChanges` - Stream to listen to authentication state changes

### 3. Updated User Model
**Location:** `/lib/models/user_model.dart`

Added new fields:
- `firebaseUserId` - Unique Firebase user ID
- `isAnonymous` - Boolean flag indicating if user is anonymous

### 4. Updated Services
**UserServices** (`/lib/services/user_services.dart`):
- Added `initializeAuth()` method that automatically signs in users anonymously
- Updated `getUserSession()` to include Firebase user information
- Integrated with AuthServices

### 5. Updated BLoC
**UserBloc** (`/lib/blocs/objects/user/user_bloc.dart`):
- Modified `_onAttempGettingUser` to call `initializeAuth()` which handles anonymous sign-in

### 6. Constants
**PreferencesKey** (`/lib/helpers/preferences_key.dart`):
- Added `FIREBASE_USER_ID` constant for storing user ID in SharedPreferences

## How It Works

### User Flow
1. **App Launch**: When the app starts, `UserBloc` dispatches `AttempGettingUser` event
2. **Auto Sign-In**: If no user is signed in, the system automatically signs in anonymously
3. **Persistent ID**: Firebase generates a unique user ID that persists across sessions
4. **Local Storage**: User ID is stored in SharedPreferences for quick access

### Data Storage
```dart
// User data is stored in two places:
1. Firebase Authentication - Manages the anonymous user session
2. SharedPreferences - Stores username and Firebase user ID locally
```

## Future Upgrade Path

The anonymous authentication is designed to be upgradeable. Users can later:
- Link their account to an email/password
- Link to phone authentication
- Link to social providers (Google, Facebook, etc.)

Use the `linkWithCredential()` method in AuthServices:
```dart
// Example: Upgrade to email/password
final credential = EmailAuthProvider.credential(
  email: email, 
  password: password
);
await authServices.linkWithCredential(credential);
```

## Firebase Console Setup

To enable anonymous authentication in Firebase:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Authentication** → **Sign-in method**
4. Click on **Anonymous**
5. Toggle **Enable** switch
6. Click **Save**

## Testing

To verify anonymous authentication is working:

1. Clear app data/reinstall the app
2. Launch the app
3. Check the logs for successful sign-in:
   ```
   User signed in anonymously: <user_id>
   ```
4. The user ID should persist across app restarts

## Security Considerations

- Anonymous users can still access Firestore if security rules allow
- Consider implementing Firestore security rules:
  ```javascript
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /turns/{document} {
        // Allow users to read/write their own data
        allow read, write: if request.auth != null && 
                             request.auth.uid == resource.data.userId;
      }
    }
  }
  ```

## Firestore Integration

When saving data to Firestore, include the Firebase user ID:

```dart
// Example: Save turn data with user ID
final user = authServices.currentUser;
if (user != null) {
  await firestore.collection('turns').add({
    'userId': user.uid,
    'username': username,
    'score': score,
    // ... other data
  });
}
```

## Migration Notes

### Existing Users
- Existing users without Firebase accounts will be automatically signed in anonymously on next app launch
- Their existing username from SharedPreferences will be preserved
- A new Firebase user ID will be assigned

### Data Migration
If you need to associate existing local data with Firebase user IDs:
1. The user ID is available in `UserModel.firebaseUserId`
2. Update existing Firestore documents with the new user ID
3. Implement migration logic in the appropriate service

## Troubleshooting

### User Not Signing In
- Check Firebase Console: Authentication → Anonymous is enabled
- Verify internet connection
- Check Firebase configuration in `firebase_options.dart`

### User ID Not Persisting
- Ensure SharedPreferences is initialized before use
- Check that `PreferencesKey.FIREBASE_USER_ID` is being saved

### Multiple Anonymous Users Created
- This can happen if the app is reinstalled or data is cleared
- Each install creates a new anonymous user
- To prevent: Implement account upgrade to permanent authentication

## Next Steps

Recommended enhancements:
1. **Update Firestore Security Rules** - Protect user data
2. **Implement Account Upgrade** - Allow users to create permanent accounts
3. **Add Sign Out Option** - Let users sign out (creates new anonymous user on next sign in)
4. **Sync User Data** - Store username and preferences in Firestore for multi-device support
5. **Analytics** - Track anonymous user behavior (respecting privacy)

## Code Examples

### Check Authentication Status
```dart
final authServices = AuthServices();
if (authServices.isSignedIn()) {
  final userId = authServices.currentUser?.uid;
  print('User is signed in: $userId');
}
```

### Listen to Auth State Changes
```dart
authServices.authStateChanges.listen((user) {
  if (user != null) {
    print('User signed in: ${user.uid}');
  } else {
    print('User signed out');
  }
});
```

### Sign Out User
```dart
await authServices.signOut();
// Note: Next time user opens app, they'll be signed in as a NEW anonymous user
```

### Delete User Account
```dart
final success = await authServices.deleteAccount();
if (success) {
  print('Account deleted successfully');
}
```

## Resources

- [Firebase Anonymous Authentication Documentation](https://firebase.google.com/docs/auth/flutter/anonymous-auth)
- [Upgrading Anonymous Accounts](https://firebase.google.com/docs/auth/flutter/account-linking)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
