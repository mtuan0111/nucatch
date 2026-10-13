# Deployment Guide (Fastlane)

Automated build & deploy for **nucatch** to Google Play and the Apple App Store /
TestFlight, driven by [Fastlane](https://fastlane.tools).

- Android package: `bomnguyen.nucatch`
- iOS bundle id: `bomnguyen.game.nucatch`

> **Golden rule:** no credential, token, keystore, or private key is ever
> hard-coded or committed. Everything sensitive is read from `.env.fastlane`
> (local, git-ignored) or from CI secrets. See [Secrets & Git hygiene](#secrets--git-hygiene).
>
> **Never put store keys in `.env`.** `pubspec.yaml` bundles `.env` into the app
> as an asset, so anything in it ships inside the APK/IPA.

---

## 1. Lanes at a glance

Fastlane is split per platform: run Android lanes from `android/`, iOS lanes from `ios/`.

| Lane | Platform | What it does | Target |
| --- | --- | --- | --- |
| `check_env` | android | Validate keys, Play JSON (against Google) and signing — uploads nothing | — |
| `deploy_staging` | android | Build release AAB → upload | Google Play **internal** track |
| `deploy_production` | android | Build release AAB → upload | Google Play **production** track |
| `deploy` | android | Alias for `deploy_production` | Google Play production |
| `distribute` | android | Upload a pre-built APK | Firebase App Distribution (`testers`) |
| `upload_screenshots` | android | Store screenshots only | Google Play (media only) |
| `check_env` | ios | Validate keys, ASC API key (against App Store Connect) and profile — uploads nothing | — |
| `deploy_staging` | ios | Build release IPA → upload | **TestFlight** (internal) |
| `deploy_production` | ios | Build release IPA → upload | **App Store Connect** (no auto-submit) |
| `deploy` | ios | Alias for `deploy_production` | App Store Connect |
| `distribute` | ios | Upload a pre-built IPA | Firebase App Distribution (`testers`) |
| `upload_screenshots` | ios | Store screenshots only | App Store Connect (media only) |

The `deploy_*` lanes do what the CHANGELOG build commands do, then upload:

1. **Version** — taken from the latest `CHANGELOG.md` block: the
   `APP_ENVIRONMENT=DEVELOPMENT` build command for staging, the `PRODUCTION`
   one for production (pubspec's version lags and would be rejected as too
   low). Override with `build_name:` / `build_number:`.
2. **Firebase config** — `npm run flutterfire_setup_dev` (staging) /
   `npm run flutterfire_setup` (production). Skip with `skip_flutterfire:true`.
3. **Build** — `flutter build appbundle` / `flutter build ipa` (release,
   `--dart-define=APP_ENVIRONMENT=…`). iOS uses manual App Store signing via a
   generated `build/ios/ExportOptions.plist` (`APPLE_TEAM_ID` +
   `IOS_PROVISIONING_PROFILE`), like the CI workflow.
4. **Upload** — `supply` (Play), `upload_to_testflight` / `deliver` (Apple).
5. **Release notes** — the "Brief for Store's new update" bullets of the
   latest block: lines with Vietnamese letters → `vi`, the rest → `en-US`.
   Play "What's new" (written to `metadata/android/<locale>/changelogs/<code>.txt`),
   TestFlight "What to Test" (en-US), App Store "What's New" (en-US, vi).

```bash
fastlane android deploy_production                       # CHANGELOG version
fastlane android deploy_production build_name:2.8.12 build_number:95
fastlane android deploy_production release_status:draft  # upload, don't roll out
fastlane ios     deploy_production submit:true           # also submit for review
```

---

## 2. Prerequisites

```bash
# Ruby + Fastlane (Bundler recommended)
brew install fastlane            # or: gem install fastlane
# from android/ and from ios/:
bundle install                   # if using the provided Gemfile

# Flutter toolchain
flutter --version
```

Local release **signing must already be set up**:

- **Android** — `android/key.properties` pointing at your keystore
  (`storeFile=../../key.jks`). See [Android keystore](#android-keystore).
- **iOS** — a valid Apple Distribution certificate + an App Store provisioning
  profile for `bomnguyen.game.nucatch` installed in your login keychain (Xcode
  "Automatically manage signing" or a manual profile). See
  [iOS signing](#ios-signing-certificate--provisioning-profile).

Then copy the deployment env template and fill it in:

```bash
cp .env.fastlane.example .env.fastlane   # git-ignored
# edit .env.fastlane, then check it (uploads nothing):
(cd android && bundle exec fastlane check_env)
(cd ios     && bundle exec fastlane check_env)
```

Both Fastfiles load `.env.fastlane` themselves (`tool/release/fastlane_common.rb`);
variables already set in the environment (CI secrets) take precedence.

---

## 3. Required environment variables

All live in `.env.fastlane` (git-ignored). Template: `.env.fastlane.example`.
Relative paths resolve from the repo root.

| Variable | Used by | Meaning |
| --- | --- | --- |
| `SUPPLY_JSON_KEY` | android `check_env`, `deploy_*`, `upload_screenshots` | Path to the Google Play service-account JSON |
| `ASC_KEY_ID` | ios `check_env`, `deploy_*`, `upload_screenshots` | App Store Connect API **Key ID** |
| `ASC_ISSUER_ID` | ios `check_env`, `deploy_*`, `upload_screenshots` | App Store Connect API **Issuer ID** |
| `ASC_KEY_FILEPATH` | ios (same) | Path to the ASC API `.p8` private key… |
| `ASC_KEY_CONTENT` | ios (same) | …or its contents, raw or base64 (for CI) |
| `APPLE_TEAM_ID` | ios `deploy_*` | Signing team (default `R23LP5MFKD`) |
| `IOS_PROVISIONING_PROFILE` | ios `deploy_*` | App Store profile name (default `NuCatch_AppStore`) |
| `FIREBASE_CLI_TOKEN` | `distribute` (both) | Firebase CI token for App Distribution |

Android release signing is **not** in this file: Gradle reads
`android/key.properties` (git-ignored) and the keystore it names;
`check_env` / `deploy_*` verify both exist.

---

## 4. How to generate each key

### Firebase CLI token
```bash
firebase login:ci
```
Copy the printed token into `FIREBASE_CLI_TOKEN`. (Used only by the Firebase
App Distribution `distribute` lanes.)

### Google Play service-account JSON  (`SUPPLY_JSON_KEY`)
1. [Google Play Console](https://play.google.com/console) → **Setup → API access**
   (or Google Cloud IAM) → **Create service account**.
2. Grant it the **Release / Release manager** role for this app.
3. Create a **JSON key** for the service account and download it.
4. Save it to `android/play-store-service-account.json` (already git-ignored) —
   the default `SUPPLY_JSON_KEY` in `.env.fastlane.example`.
5. Sanity check: `cd android && bundle exec fastlane check_env`

> The app must already exist on Play with at least one manual release before
> `supply` can upload to a track.

### App Store Connect API key  (`ASC_KEY_ID` / `ASC_ISSUER_ID` / `ASC_KEY_FILEPATH`)
1. [App Store Connect](https://appstoreconnect.apple.com) → **Users and Access →
   Integrations → App Store Connect API**.
2. **Generate API Key** with the **App Manager** role.
3. Note the **Key ID** (`ASC_KEY_ID`) and the **Issuer ID** (`ASC_ISSUER_ID`,
   shown above the key list).
4. Download the `.p8` **once** (Apple only lets you download it once). Save it to
   `ios/private_keys/AuthKey_<KEY_ID>.p8` (git-ignored) and point
   `ASC_KEY_FILEPATH` at it.
5. Sanity check: `cd ios && bundle exec fastlane check_env` (also confirms the
   key can see `bomnguyen.game.nucatch` and that the profile is installed).

### Android keystore  (local release signing)
Only needed once, if you don't already have `key.jks`:
```bash
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias upload
```
Create `android/key.properties` (git-ignored):
```properties
storePassword=********
keyPassword=********
keyAlias=upload
storeFile=../../key.jks
```
> Keep `key.jks` **out of git** and backed up securely — losing it means you can
> no longer update the app on Play.

### iOS signing (certificate + provisioning profile)
For **local** deploys, the simplest path is Xcode-managed signing:
`open ios/Runner.xcworkspace` → Runner target → Signing & Capabilities → sign in
with an Apple Developer account that can produce an **Apple Distribution**
certificate + an **App Store** provisioning profile for `bomnguyen.game.nucatch`.

For **CI / reproducible** signing, either adopt
[`fastlane match`](https://docs.fastlane.tools/actions/match/) (recommended), or
import a certificate + profile from secrets (this is what the GitHub workflows
already do — see below).

---

## 5. Run a deploy locally

```bash
# ----- Android -----
cd android
bundle exec fastlane deploy_staging       # → Google Play internal track
bundle exec fastlane deploy_production     # → Google Play production track
bundle exec fastlane deploy                # alias for deploy_production

# ----- iOS -----
cd ios
bundle exec fastlane deploy_staging        # → TestFlight
bundle exec fastlane deploy_production      # → App Store Connect (submit manually)
```

(Drop `bundle exec` if you installed Fastlane globally.)

Firebase App Distribution (pre-built binary):
```bash
flutter build apk --release && cd android && bundle exec fastlane distribute
flutter build ipa --export-method ad-hoc --release && cd ios && bundle exec fastlane distribute
```

---

## 6. CI

This repo already ships a **GitHub Actions** pipeline in `.github/workflows/`
(`deploy_android_internal.yml`, `deploy_android_release.yml`,
`deploy_ios_internal.yml`, `deploy_ios_release.yml`) plus `.gitlab-ci.yml`. Those
handle version bumping and TestFlight→App Store promotion directly.

To call the **Fastlane lanes** from CI instead (or in addition), materialise the
secret files from CI secrets first, then invoke the lane. Example (GitHub Actions):

```yaml
- name: Deploy Android (production)
  working-directory: android
  env:
    SUPPLY_JSON_KEY: ${{ github.workspace }}/android/play-store-service-account.json
  run: |
    echo "${{ secrets.SERVICE_ACCOUNT_JSON_BASE64_PRD }}" | base64 -d > "$SUPPLY_JSON_KEY"
    echo "${{ secrets.KEYSTORE_BASE64_PRD }}"      | base64 -d > "$GITHUB_WORKSPACE/key.jks"
    echo "${{ secrets.KEY_PROPERTIES_BASE64_PRD }}" | base64 -d > android/key.properties
    bundle exec fastlane deploy_production

- name: Deploy iOS (TestFlight)
  working-directory: ios
  env:
    ASC_KEY_ID:       ${{ secrets.ASC_KEY_ID }}
    ASC_ISSUER_ID:    ${{ secrets.APP_STORE_CONNECT_API_ISSUER_ID }}
    ASC_KEY_FILEPATH: ${{ github.workspace }}/ios/private_keys/AuthKey.p8
  run: |
    mkdir -p ios/private_keys
    echo "${{ secrets.APP_STORE_CONNECT_API_KEY_CONTENT }}" > "$ASC_KEY_FILEPATH"
    # + import IOS_CERTIFICATE_BASE64 / IOS_PROVISIONING_PROFILE_BASE64 into a keychain
    bundle exec fastlane deploy_staging
```

Existing GitHub secrets these map to: `SERVICE_ACCOUNT_JSON_BASE64_PRD`,
`KEYSTORE_BASE64_PRD`, `KEY_PROPERTIES_BASE64_PRD`,
`APP_STORE_CONNECT_API_KEY_CONTENT`, `APP_STORE_CONNECT_API_ISSUER_ID`,
`IOS_CERTIFICATE_BASE64`, `IOS_PROVISIONING_PROFILE_BASE64`,
`CERTIFICATE_PASSWORD`, `KEYCHAIN_PASSWORD`.

---

## Secrets & Git hygiene

`.gitignore` now excludes all of these: `.env` (+ variants), `**/key.properties`,
`**/*.jks`, `**/*.keystore`, `**/*.p8`, `**/*.p12`, `**/*.mobileprovision`,
`ios/private_keys/`, and Fastlane run artifacts. Only `.env.example` (no real
values) is committed.

> ### ⚠️ Action required: signing keystores were committed to git history
> `git ls-files` shows **`key.jks`** and **`upload-keystore.jks`** are tracked.
> Adding them to `.gitignore` stops *future* commits but does **not** remove them
> from history. Recommended remediation:
> ```bash
> git rm --cached key.jks upload-keystore.jks   # untrack, keep local copies
> git commit -m "chore: stop tracking signing keystores"
> ```
> Because the keystore was exposed in history, consider **rotating the upload key**
> (Play App Signing lets you request an upload-key reset) and purging it from
> history (e.g. `git filter-repo`). Treat the same way any `.p8` / service-account
> JSON that may have been committed previously.
