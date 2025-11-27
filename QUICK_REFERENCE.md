# 🔥 Firebase Anonymous Auth - Quick Reference

## Enable in Firebase Console (2 min)
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. **Authentication** → **Sign-in method** → **Anonymous** → **Enable** → **Save**

## Code Usage

### Get Current User
```dart
import 'package:nucatch/services/auth_services.dart';

final authServices = AuthServices();
final user = authServices.currentUser;

if (user != null) {
  String userId = user.uid;
  bool isAnonymous = user.isAnonymous;
}
```

### Check Authentication Status
```dart
if (authServices.isSignedIn()) {
  // User is authenticated
}
```

### Sign Out (Creates new user on next launch)
```dart
await authServices.signOut();
```

### Upgrade Anonymous Account
```dart
// Example: Link to email/password
final credential = EmailAuthProvider.credential(
  email: email,
  password: password,
);
final result = await authServices.linkWithCredential(credential);
```

### Listen to Auth Changes
```dart
authServices.authStateChanges.listen((user) {
  if (user != null) {
    print('Signed in: ${user.uid}');
  } else {
    print('Signed out');
  }
});
```

## Debug Widget (Development)
```dart
import 'package:nucatch/helpers/auth_debug_widget.dart';
import 'package:flutter/foundation.dart';

// Add to your screen:
if (kDebugMode) const AuthDebugWidget()
```

## Firestore Integration
```dart
// Save data with user ID
final userId = authServices.currentUser?.uid;

await firestore.collection('turns').add({
  'userId': userId,
  'score': score,
  // ... other fields
});

// Query user's data
final snapshot = await firestore
  .collection('turns')
  .where('userId', isEqualTo: userId)
  .get();
```

## Security Rules (Firestore)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Require authentication
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
    
    // Users can only write their own data
    match /turns/{turnId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                     request.auth.uid == request.resource.data.userId;
    }
  }
}
```

## Files Modified
- ✅ `pubspec.yaml` - Added firebase_auth
- ✅ `lib/services/auth_services.dart` - NEW
- ✅ `lib/services/user_services.dart` - Updated
- ✅ `lib/blocs/objects/user/user_bloc.dart` - Updated
- ✅ `lib/models/user_model.dart` - Added firebaseUserId
- ✅ `lib/helpers/preferences_key.dart` - Added constant

## User Model
```dart
class UserModel {
  final String? username;
  final String? firebaseUserId;  // NEW
  final bool isAnonymous;        // NEW
}
```

## Auto Sign-In Flow
App starts → `UserBloc` initializes → Checks if signed in → 
If not signed in → Signs in anonymously → User ID saved → App ready

## Testing
1. Clear app data/reinstall
2. Launch app
3. Check logs for sign-in success
4. Verify in Firebase Console → Authentication → Users

## Common Issues
| Issue | Solution |
|-------|----------|
| User not signing in | Enable Anonymous auth in Firebase Console |
| Different ID each time | Check SharedPreferences is working |
| Firestore permission denied | Update security rules |

## Documentation
- 📖 `IMPLEMENTATION_SUMMARY.md` - Overview
- 📋 `FIREBASE_AUTH_CHECKLIST.md` - Setup steps
- 📚 `FIREBASE_AUTH_SETUP.md` - Full documentation
- 📝 `README.md` - Quick start

## Status
✅ Code: Complete  
⏳ Firebase Console: Needs enabling  
⏳ Testing: Ready to test

**Next:** Enable Anonymous Auth in Firebase Console!
