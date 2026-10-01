# Runbook — finishing Google / Apple sign-in setup

The app-side flow is done: `AuthServices` (in `skeleton_core`) does
link-or-sign-in for both providers, `UserBloc` exposes the events, and
Settings → **Account** opens the sign-in sheet. Nothing below is code — it
is the console + native config that those calls depend on, and **until it is
done both buttons will fail on every device**.

Ported from `mind_compass/docs/SNS_LOGIN_SETUP.md`; the flow and the failure
modes are identical, the identifiers are not.

## Your project's values

Copy-paste these rather than re-deriving them — several steps fail silently
if a value is subtly wrong.

| What | Value |
|---|---|
| Firebase project | `nucatch-74040546` (project number `749675143292`) |
| Android package | `bomnguyen.nucatch` |
| iOS bundle ID | `bomnguyen.game.nucatch` |
| Apple Team ID | _(from developer.apple.com → Membership)_ |
| Debug SHA-1 | `D3:AF:1C:47:85:AA:89:14:1F:EB:DE:99:D3:A1:55:87:18:FE:33:C3` |
| Debug SHA-256 | `2F:3A:D3:7A:22:8A:DF:B1:6D:A9:DA:A6:CD:28:60:24:06:26:D7:94:36:73:BC:CD:EF:B3:05:C2:D8:5E:76:1C` |
| Release SHA-1 | `27:4C:ED:E9:04:61:AF:38:57:B3:2D:AE:0D:93:63:7F:F5:EC:7A:19` |
| Release SHA-256 | `C3:0A:82:F0:41:AF:31:71:E6:F0:CC:CC:5A:15:BC:40:EA:43:FF:8D:DF:45:98:C4:99:1D:65:46:45:11:08:91` |

> ⚠️ **Both** fingerprint pairs matter here. Unlike some projects, nucatch
> signs release with a real keystore (`android/key.properties` →
> `signingConfigs.release`), so the debug and release certificates differ.
> Register only the debug pair and Google sign-in works in `flutter run` and
> then breaks in the Play build — the classic late surprise.

Regenerate them any time with:

```bash
# debug
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey -storepass android -keypass android | grep -E 'SHA1|SHA256'
# release — reads android/key.properties for the store path/alias
keytool -list -v -keystore <storeFile> -alias <keyAlias> | grep -E 'SHA1|SHA256'
```

---

## 1. Android — Google sign-in (required; currently non-functional)

**Symptom if skipped:** the Google button fails instantly on Android.

**Why:** `android/app/google-services.json` currently has an **empty**
`oauth_client` array — not even a web client. Android needs a
`client_type: 1` entry (generated once your signing certificates are
registered) *and* a `client_type: 3` (web) entry to hand back an ID token.

1. Firebase Console → `nucatch-74040546` → ⚙️ **Project settings** → **General**
2. Under **Your apps**, select the Android app (`bomnguyen.nucatch`)
3. **Add fingerprint** → paste **Debug SHA-1** → save
4. Repeat for **Debug SHA-256**, **Release SHA-1**, and **Release SHA-256**
5. Console → **Authentication** → **Sign-in method** → enable **Google** → save
6. Back in **Project settings**, **download the fresh `google-services.json`**
   and replace `android/app/google-services.json`

Verify the new file actually has both clients (this should print `1` and `3`):

```bash
python3 -c "
import json;d=json.load(open('android/app/google-services.json'))
print([o.get('client_type') for c in d['client'] for o in c.get('oauth_client',[])])
"
```

If the list is still empty, the fingerprints didn't register — recheck step 3.

> Once that file has a `client_type: 3` entry, pass its `client_id` as
> `serverClientId` to `GoogleSignIn.initialize()` in
> `skeleton_core/lib/src/services/auth_services.dart`. Android returns a
> **null `idToken`** without it, which the service already detects and
> reports as `authErrorCredentialRejected` rather than letting Firebase fail
> with something vaguer.

---

## 2. iOS — Google sign-in

**Symptom if skipped:** the Google sheet never appears on iOS.

`ios/Runner/GoogleService-Info.plist` currently has **no `CLIENT_ID` /
`REVERSED_CLIENT_ID`** — those appear only once the Google provider is
enabled and the file is re-downloaded.

1. Do §1 step 5 first (enable Google in Authentication)
2. **Project settings** → the iOS app (`bomnguyen.game.nucatch`) →
   download the fresh **`GoogleService-Info.plist`** → replace
   `ios/Runner/GoogleService-Info.plist`
3. Confirm it now has the two keys:
   ```bash
   plutil -p ios/Runner/GoogleService-Info.plist | grep -E 'CLIENT_ID|REVERSED'
   ```
4. Add to `ios/Runner/Info.plist`:
   - `GIDClientID` = the `CLIENT_ID` value
   - a URL scheme entry whose `CFBundleURLSchemes` contains the
     `REVERSED_CLIENT_ID` value

```xml
<key>GIDClientID</key>
<string>PASTE_CLIENT_ID_HERE</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array><string>PASTE_REVERSED_CLIENT_ID_HERE</string></array>
  </dict>
</array>
```

---

## 3. Apple — enable the provider (required for both platforms)

**Symptom if skipped:** on iOS the native sheet appears, you authenticate,
and it then fails at the *credential exchange* — an error that is **not**
`authErrorAppleUnavailable`. On Android it fails at the redirect.

Needs a **paid** Apple Developer Program membership.

### 3a. Xcode — capability + entitlement

nucatch has **no `ios/Runner/Runner.entitlements`** today, so this must be
created:

1. Open `ios/Runner.xcworkspace` → target **Runner** → **Signing &
   Capabilities** → **+ Capability** → **Sign in with Apple**
2. That creates `Runner.entitlements` with
   `com.apple.developer.applesignin`. Confirm it is wired into **all**
   build configurations (Debug/Release/Profile), not just Debug
3. Verify it actually made it into the signed binary:
   ```bash
   codesign -d --entitlements - build/ios/iphoneos/Runner.app 2>/dev/null | grep applesignin
   ```

Missing entitlement surfaces as `AuthorizationErrorCode.unknown` — which the
service now logs verbatim, so check the run output rather than guessing.

### 3b. Apple Developer portal — Services ID and key

1. [developer.apple.com](https://developer.apple.com) → **Certificates,
   Identifiers & Profiles** → **Identifiers**
2. Confirm the App ID `bomnguyen.game.nucatch` has **Sign In with Apple** checked
3. **Identifiers** → **+** → **Services IDs** → Continue
   - Identifier: something distinct from the bundle ID, e.g.
     `bomnguyen.game.nucatch.signin`
   - Register it, then **open it** → tick **Sign In with Apple** → **Configure**:
     - Primary App ID: `bomnguyen.game.nucatch`
     - **Return URL**:
       `https://nucatch-74040546.firebaseapp.com/__/auth/handler`
   - Save, and note the Services ID
4. **Keys** → **+** → tick **Sign In with Apple** → **Configure** → primary
   App ID `bomnguyen.game.nucatch` → Save → **Register** → **download the `.p8`**
   - Downloadable **once**. Keep it out of the repo.
   - Note the **Key ID** (10 chars)

### 3c. Firebase Console — turn on the provider

**Authentication** → **Sign-in method** → **Apple** → enable, then fill in
the **Services ID**, **Apple Team ID**, **Key ID**, and the `.p8` contents.

> Native iOS sign-in can work with just the App ID capability, but Firebase
> requires the Services ID + key to verify the token server-side, so this is
> not optional.
>
> **Android depends on §3b/§3c entirely.** Apple ships no native
> authorization UI off its own platforms, so Android signs in through
> Firebase's hosted OAuth handler — the exact Return URL configured above.
> If those are incomplete, Android fails at the redirect and surfaces as
> `invalid-credential` → `authErrorCredentialRejected`.

---

## 4. Verify on device

Both flows end in native OS UI that automated tests cannot drive, so these
are by hand.

```bash
flutter run -d <device-id>   # device ids: flutter devices
```

Menu → **Settings** → **Account** → **Sign in**, then:

| Test | Expected | If it fails |
|---|---|---|
| **Google, iOS** | Account chooser appears; picking one returns signed in | Sheet doesn't appear → §2 (`GIDClientID` + URL scheme) |
| **Google, Android** | Same | Fails instantly → §1 not complete |
| **Apple, iOS** | Apple ID sheet; Face/Touch ID → signed in | Sheet appears then errors → §3b/§3c. Sheet never appears → §3a entitlement |
| **Apple, Android** | A Chrome Custom Tab opens Apple's web sign-in, then returns signed in | Apple shows "invalid_request" → Return URL mismatch in §3b. Returns but Firebase rejects → §3c. Dismissing the tab counts as a cancel, not an error |

Then confirm the **upgrade actually stuck**, which is the whole point:

1. Play a round as a guest and let a score post to the leaderboard
2. Sign in
3. The leaderboard entry is still marked as yours, and Settings shows
   *Signed in as …*

Same `uid` is kept via account linking (`AuthServices._linkOrSignInWith`), so
scores follow the player. If the account already existed, you get the
**Account already in use** dialog instead — confirming there *switches* to
that account and deliberately leaves the guest scores behind.

### Reading failures

`auth_services.dart` logs the underlying cause, not just the user-facing key:

- `Google sign-in failed: code=…` — `clientConfigurationError` /
  `providerConfigurationError` mean §1 is incomplete
- `Google sign-in returned no idToken` — `serverClientId` missing (§1 note)
- `Sign in with Apple failed: code=…` — `unknown` is almost always the §3a
  entitlement, not user error
- `Apple identity token claims: aud=… nonceMatchesSent=…` (debug builds) —
  `aud` must be the bundle ID that Firebase's Apple provider knows

---

## Already done (no action needed)

- `AuthServices` — Google + Apple, link-or-sign-in on top of the existing
  anonymous session, conflict stash + `signInWithPendingCredential()`, and
  the `FirebaseAuthException` → l10n-key mapping
- `UserBloc` — `SignInWithGoogleRequested` / `SignInWithAppleRequested` /
  `AccountSwitchConfirmed` / `LinkConflictDismissed` / `SignOutRequested`,
  with cancel treated as a non-error
- UI — `showSignInSheet()`, the link-conflict dialog, and the Settings
  **Account** row, localized into all 10 supported locales
