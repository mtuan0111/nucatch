# Firebase Anonymous Authentication - Setup Checklist

## ✅ Code Implementation (Completed)

- [x] Added `firebase_auth: ^6.1.1` dependency to `pubspec.yaml`
- [x] Created `AuthServices` class (`/lib/services/auth_services.dart`)
- [x] Updated `UserModel` with `firebaseUserId` and `isAnonymous` fields
- [x] Updated `UserServices` with `initializeAuth()` method
- [x] Updated `UserBloc` to use Firebase authentication
- [x] Added `FIREBASE_USER_ID` constant to `PreferencesKey`
- [x] Created comprehensive documentation (`FIREBASE_AUTH_SETUP.md`)
- [x] Created debug widget for testing (`/lib/helpers/auth_debug_widget.dart`)
- [x] Updated README.md with Firebase authentication section

## 🔧 Firebase Console Setup (Required)

### Step 1: Enable Anonymous Authentication
- [ ] Go to [Firebase Console](https://console.firebase.google.com/)
- [ ] Select your project: **nucatch-with-bloc**
- [ ] Navigate to **Build** → **Authentication**
- [ ] Click on **Sign-in method** tab
- [ ] Find **Anonymous** in the list of providers
- [ ] Click on **Anonymous**
- [ ] Toggle the **Enable** switch to ON
- [ ] Click **Save**

### Step 2: Update Firestore Security Rules (Recommended)
- [ ] Go to **Build** → **Firestore Database**
- [ ] Click on **Rules** tab
- [ ] Update rules to require authentication:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Default: Require authentication for all operations
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
    
    // Optional: Users can only read/write their own data
    match /turns/{turnId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                     request.auth.uid == request.resource.data.userId;
    }
  }
}
```

- [ ] Click **Publish**

### Step 3: (Optional) Add User ID to Firestore Documents
If you want to associate Firestore data with users:

- [ ] Update `turn_services.dart` to include `userId` when saving turns:

```dart
import 'package:nucatch/services/auth_services.dart';

class TurnRecordedServices {
  final AuthServices _authServices = AuthServices();
  
  // In your save method:
  Future<void> saveTurn(TurnRecorded turn) async {
    final userId = _authServices.currentUser?.uid;
    
    await _firestore.collection('turns').add({
      'userId': userId,
      'username': turn.playedUsername,
      'score': turn.point,
      'difficulty': turn.difficulty,
      'recordedTime': turn.recordedTime,
      // ... other fields
    });
  }
}
```

## 🧪 Testing

### Test 1: First Time User
- [ ] Uninstall the app completely (or clear app data)
- [ ] Install and launch the app
- [ ] Expected: User should be automatically signed in anonymously
- [ ] Check logs for: `User signed in anonymously: [user_id]`

### Test 2: Returning User
- [ ] Close the app completely
- [ ] Relaunch the app
- [ ] Expected: Same user ID should be used (persists across sessions)
- [ ] Verify in logs or using debug widget

### Test 3: Debug Widget (Development Only)
- [ ] Add `AuthDebugWidget` to a screen temporarily:

```dart
import 'package:nucatch/helpers/auth_debug_widget.dart';
import 'package:flutter/foundation.dart';

// In your widget build method:
Column(
  children: [
    // Your existing widgets
    if (kDebugMode) const AuthDebugWidget(),
  ],
)
```

- [ ] Build and run the app
- [ ] Verify the debug widget shows:
  - Status: Authenticated
  - User ID: [partial ID]
  - Anonymous: true

### Test 4: Firebase Console Verification
- [ ] Go to Firebase Console → Authentication → Users
- [ ] You should see anonymous users listed
- [ ] Each anonymous user has a unique UID
- [ ] Provider shows as "Anonymous"

## 📝 Post-Implementation Tasks

### Update Turn Services (Optional)
If you want to sync user data with Firestore:

- [ ] Modify `getTurnedListByPeriod` to filter by user ID
- [ ] Update `insertTurnedToFirebase` to include user ID
- [ ] Consider adding user ID to Firestore security rules

### Example Code:
```dart
// In turn_services.dart
Future<void> insertTurnedToFirebase(TurnRecorded turn) async {
  final userId = _authServices.currentUser?.uid;
  
  await _firestore.collection(PreferencesKey.LIST_TURN_RECORDED).add({
    PreferencesKey.TURN_ID: turn.turnId,
    PreferencesKey.PLAYED_USERNAME: turn.playedUsername,
    PreferencesKey.POINT: turn.point,
    PreferencesKey.RECORDED_TIME: turn.recordedTime?.millisecondsSinceEpoch,
    PreferencesKey.DIFFICULTY: turn.difficulty?.value,
    'userId': userId, // Add this line
  });
}
```

### Future Enhancements
- [ ] Implement account upgrade (anonymous → email/phone)
- [ ] Add user profile sync to Firestore
- [ ] Implement cross-device data sync
- [ ] Add sign-out option in settings
- [ ] Implement account deletion feature

## 🚨 Common Issues & Solutions

### Issue: User not signing in
**Solution:**
1. Check Firebase Console: Anonymous auth is enabled
2. Verify internet connection
3. Check `firebase_options.dart` is properly configured
4. Look for error logs in console

### Issue: Different user ID on each app launch
**Solution:**
1. Check that SharedPreferences is working
2. Verify `PreferencesKey.FIREBASE_USER_ID` is being saved
3. Ensure `await` is used when saving preferences

### Issue: Firestore permission denied
**Solution:**
1. Update Firestore security rules to allow authenticated users
2. Verify user is actually signed in (`_authServices.currentUser != null`)
3. Check Firebase Console rules simulator

## 📚 Resources

- [Firebase Anonymous Auth Documentation](https://firebase.google.com/docs/auth/flutter/anonymous-auth)
- [Account Linking](https://firebase.google.com/docs/auth/flutter/account-linking)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Flutter Firebase Setup](https://firebase.google.com/docs/flutter/setup)

## ✨ Success Criteria

You've successfully implemented Firebase Anonymous Authentication when:

- [x] Code compiles without errors
- [ ] Firebase Console shows Anonymous auth is enabled
- [ ] App automatically signs in users on first launch
- [ ] User ID persists across app restarts
- [ ] Firebase Console → Authentication shows anonymous users
- [ ] Debug widget (in development) shows user is authenticated
- [ ] (Optional) Firestore data is associated with user IDs

---

**Status:** Code implementation complete ✅  
**Next Step:** Enable Anonymous Authentication in Firebase Console (see Step 1 above)

**Estimated Time to Complete:** 5-10 minutes (Firebase Console setup only)
