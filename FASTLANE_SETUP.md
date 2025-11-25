# Fastlane Setup and Usage Guide

This document explains how to use Fastlane for automated deployment of the nucatch Flutter app to Google Play Store and Apple App Store.

## Prerequisites

### General
- Fastlane installed: `gem install fastlane -NV`
- Flutter SDK installed and configured
- Project dependencies installed: `flutter pub get`

### Android
- Google Play Console account
- Service account JSON key file for Play Store API access
- Properly configured `key.properties` for signing
- Upload keystore (`key.jks`) configured

### iOS
- Apple Developer account
- App Store Connect access
- Code signing certificates and provisioning profiles
- Xcode installed with command line tools

## Setup

### Android Setup

1. **Configure Service Account** (for Google Play Store API):
   - Create a service account in Google Cloud Console
   - Download the JSON key file
   - Place it in a secure location (e.g., `~/fastlane-credentials/play-store-key.json`)
   - Grant the service account necessary permissions in Google Play Console

2. **Update Appfile** (`android/fastlane/Appfile`):
   ```ruby
   json_key_file("/path/to/your/service-account-key.json")
   package_name("your.package.name")
   ```

### iOS Setup

1. **Configure App Store Connect**:
   - Ensure your app is registered in App Store Connect
   - Have your Apple ID credentials ready

2. **Update Appfile** (`ios/fastlane/Appfile`):
   ```ruby
   app_identifier("your.bundle.identifier")
   apple_id("your@email.com")
   team_id("YOUR_TEAM_ID")
   ```

3. **Code Signing** (optional, using match):
   ```bash
   cd ios
   fastlane match init
   fastlane sync_signing
   ```

## Available Lanes

### Android Lanes

From the `android/` directory:

#### Build
```bash
fastlane build
```
Builds a release App Bundle (`.aab`) for distribution.

#### Build APK
```bash
fastlane build_apk
```
Builds a release APK for testing or distribution.

#### Beta
```bash
fastlane beta
```
Builds and uploads the app to Google Play Internal Testing track.

#### Release
```bash
fastlane release
```
Builds and uploads the app to Google Play Production track with metadata.

#### Promote to Beta
```bash
fastlane promote_to_beta
```
Promotes the app from Internal Testing to Beta track.

#### Promote to Production
```bash
fastlane promote_to_production
```
Promotes the app from Beta to Production track.

### iOS Lanes

From the `ios/` directory:

#### Build
```bash
fastlane build
```
Builds the iOS app without code signing (for testing build process).

#### Archive
```bash
fastlane archive
```
Builds and archives the iOS app with code signing, creates an IPA file.

#### Beta
```bash
fastlane beta
```
Builds, archives, and uploads the app to TestFlight for beta testing.

#### Release
```bash
fastlane release
```
Builds, archives, and uploads the app to App Store Connect for review.

#### Screenshots
```bash
fastlane screenshots
```
Captures and uploads localized screenshots to App Store Connect.

#### Sync Signing
```bash
fastlane sync_signing
```
Syncs code signing certificates and profiles using match.

## Usage Examples

### Deploy to Android Internal Testing
```bash
cd android
fastlane beta
```

### Deploy to iOS TestFlight
```bash
cd ios
fastlane beta
```

### Full Release to Production (Android)
```bash
cd android
fastlane build           # Build first (optional)
fastlane beta            # Upload to internal testing
fastlane promote_to_beta # Promote to beta
# Test in beta, then:
fastlane promote_to_production
```

### Full Release to App Store (iOS)
```bash
cd ios
fastlane beta    # Upload to TestFlight for testing
# After testing:
fastlane release # Upload to App Store for review
```

## CI/CD Integration

### GitHub Actions Example

Create `.github/workflows/deploy-android.yml`:

```yaml
name: Deploy Android

on:
  push:
    tags:
      - 'v*'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Setup Fastlane
        run: gem install fastlane
      
      - name: Decode keystore
        run: echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/key.jks
      
      - name: Decode service account JSON
        run: echo "${{ secrets.PLAY_STORE_JSON }}" | base64 -d > play-store-key.json
      
      - name: Deploy to Play Store
        working-directory: android
        run: fastlane beta
```

### GitLab CI Example

Create `.gitlab-ci.yml`:

```yaml
deploy:android:
  stage: deploy
  image: cirrusci/flutter:stable
  before_script:
    - gem install fastlane
    - flutter pub get
  script:
    - cd android
    - fastlane beta
  only:
    - tags
```

## Troubleshooting

### Android Issues

**Issue**: `Supply::InvalidParameters` error
- **Solution**: Ensure service account JSON is valid and has correct permissions

**Issue**: Build fails with signing error
- **Solution**: Check `key.properties` and ensure keystore path is correct

### iOS Issues

**Issue**: Code signing error
- **Solution**: Run `fastlane sync_signing` or manually configure certificates

**Issue**: Upload fails to TestFlight
- **Solution**: Ensure app version/build number is incremented

## Security Best Practices

1. **Never commit sensitive files**:
   - Add to `.gitignore`:
     ```
     *.jks
     key.properties
     **/fastlane/report.xml
     **/fastlane/Preview.html
     **/fastlane/screenshots
     **/fastlane/test_output
     play-store-key.json
     ```

2. **Use environment variables for secrets**:
   ```ruby
   # In Fastfile
   json_key_file(ENV["PLAY_STORE_KEY_PATH"])
   ```

3. **Encrypt sensitive files** in CI/CD:
   - Use GitHub Secrets, GitLab CI/CD variables, or similar

## Additional Resources

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [Flutter Deployment Guide](https://flutter.dev/docs/deployment)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)

## Notes

- Always test beta builds before promoting to production
- Increment version numbers before each release
- Keep your service account credentials secure
- Monitor deployment logs for any issues
