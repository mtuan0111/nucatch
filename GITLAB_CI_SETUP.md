# GitLab CI/CD Setup Guide

This guide explains how to configure GitLab CI/CD for automated deployment of the nucatch Flutter app to Google Play Store and Apple App Store.

## Overview

The GitLab CI/CD pipeline (`.gitlab-ci.yml`) includes three stages:

**Stages:**
1. **test** - Runs linting, analysis, and tests on merge requests and pushes
2. **build** - Builds debug/release APKs, AABs, and iOS apps
3. **deploy** - Deploys to Google Play Store and App Store (manual trigger)

**Jobs:**
- `analyze` - Flutter analysis and code formatting check
- `test` - Run unit tests with coverage reporting
- `build:android:debug` - Build debug APK for testing
- `build:android:release` - Build release AAB and APK
- `build:ios` - Build iOS app (requires macOS runner)
- `deploy:android:internal` - Deploy to Google Play Internal Testing
- `deploy:android:beta` - Deploy to Google Play Beta
- `deploy:android:production` - Deploy to Google Play Production
- `deploy:ios:testflight` - Deploy to TestFlight
- `deploy:ios:appstore` - Deploy to App Store

## Required GitLab CI/CD Variables

Navigate to your GitLab project → Settings → CI/CD → Variables

### Android Variables

| Variable Name | Type | Description | How to Obtain |
|---------------|------|-------------|---------------|
| `ANDROID_KEYSTORE_BASE64` | Variable | Base64-encoded Android keystore file | `base64 -i upload-keystore.jks` or `base64 -w 0 upload-keystore.jks` (Linux) |
| `ANDROID_KEY_STORE_PASSWORD` | Variable (Masked) | Keystore password | From your keystore creation |
| `ANDROID_KEY_PASSWORD` | Variable (Masked) | Key password | From your keystore creation |
| `ANDROID_KEY_ALIAS` | Variable | Key alias | From your keystore creation |
| `PLAY_STORE_JSON_BASE64` | Variable | Base64-encoded Google Play service account JSON | `base64 -i play-store-key.json` or `base64 -w 0 play-store-key.json` (Linux) |

#### Creating Android Keystore

If you don't have a keystore:

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Save the passwords and alias for the variables above.

#### Creating Google Play Service Account

**Step 1: Enable Google Play Android Developer API**

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project (or create a new one)
3. In the search bar at the top, type "Google Play Android Developer API"
4. Click on "Google Play Android Developer API"
5. Click "Enable" button
6. Wait for the API to be enabled (may take a few seconds)

**Step 2: Create a Service Account**

1. In Google Cloud Console, go to "IAM & Admin" → "Service Accounts"
   - Or use direct link: https://console.cloud.google.com/iam-admin/serviceaccounts
2. Click "Create Service Account" button at the top
3. Fill in the service account details:
   - **Service account name**: `google-play-publisher` (or any descriptive name)
   - **Service account ID**: Will auto-populate (e.g., `google-play-publisher@your-project.iam.gserviceaccount.com`)
   - **Description**: "Service account for automated Google Play deployments via CI/CD"
4. Click "Create and Continue"
5. Skip the optional "Grant this service account access to project" step (not needed for Play Store)
6. Click "Continue"
7. Skip the optional "Grant users access to this service account" step
8. Click "Done"

**Step 3: Create and Download JSON Key**

1. In the Service Accounts list, find the service account you just created
2. Click on the service account email to open its details
3. Go to the "Keys" tab
4. Click "Add Key" → "Create new key"
5. Select "JSON" as the key type
6. Click "Create"
7. The JSON key file will automatically download to your computer
   - File will be named something like `your-project-abc123.json`
   - **IMPORTANT**: Save this file securely - you cannot download it again!
   - Rename it to something memorable like `play-store-service-account.json`

**Step 4: Link Service Account to Google Play Console**

1. Go to [Google Play Console](https://play.google.com/console/)
2. Select your app (or create one if you haven't already)
3. Navigate to "Setup" → "API access" in the left sidebar
4. Under "Service accounts", click "Link existing service account" or "View service accounts"
5. If this is your first time:
   - Click "Choose a project to link"
   - Select your Google Cloud project from the list
   - Click "Link project"
6. You should now see your service account listed
7. Click "Grant access" next to your service account

**Step 5: Grant Permissions to Service Account**

1. In the "Grant access" dialog, configure permissions:
   - **Account permissions**: Select "Admin (all permissions)" for full deployment capabilities
     - OR for minimal permissions, select only:
       - "View app information and download bulk reports"
       - "Manage production releases" (for production deployment)
       - "Manage testing track releases" (for internal/beta deployment)
       - "Manage store presence" (for updating store listing)
2. Under "App permissions", select your app(s)
3. Click "Apply" at the bottom
4. Review the permissions summary
5. Click "Send invite" (note: despite the name, this grants immediate access)

**Step 6: Verify Service Account Access**

1. Back in "API access" page, verify your service account appears with "Active" status
2. Check that the permissions shown match what you granted
3. The service account should show your app name(s) under "App access"

**Step 7: Convert JSON Key to Base64 for GitLab**

On macOS/Linux:
```bash
# Navigate to where you saved the JSON file
cd ~/Downloads

# Convert to base64 (macOS)
base64 -i play-store-service-account.json | pbcopy

# Or on Linux (without line breaks)
base64 -w 0 play-store-service-account.json

# The base64 string is now in your clipboard (macOS) or printed to terminal (Linux)
```

On Windows (PowerShell):
```powershell
# Navigate to where you saved the JSON file
cd $env:USERPROFILE\Downloads

# Convert to base64
[Convert]::ToBase64String([IO.File]::ReadAllBytes("play-store-service-account.json")) | Set-Clipboard

# The base64 string is now in your clipboard
```

**Step 8: Add to GitLab CI/CD Variables**

1. Go to your GitLab project
2. Navigate to Settings → CI/CD
3. Expand "Variables" section
4. Click "Add Variable"
5. Configure the variable:
   - **Key**: `PLAY_STORE_JSON_BASE64`
   - **Value**: Paste the base64-encoded string
   - **Type**: Variable
   - **Environment scope**: All (default)
   - **Protect variable**: ✓ (recommended for production)
   - **Mask variable**: ✗ (cannot mask base64 strings due to length)
   - **Expand variable reference**: ✗ (leave unchecked)
6. Click "Add variable"

**Troubleshooting**

**Issue**: "The service account does not have permission to perform this action"
- Solution: Ensure you granted "Admin" permissions or the specific release management permissions in Step 5

**Issue**: "Service account not found" during deployment
- Solution: Verify the JSON file is correctly base64-encoded and added to GitLab variables
- Check that there are no extra spaces or line breaks in the base64 string

**Issue**: "The project does not have Google Play Android Developer API enabled"
- Solution: Go back to Step 1 and ensure the API is enabled in Google Cloud Console

**Issue**: Cannot see service account in Google Play Console
- Solution: Make sure you linked the correct Google Cloud project in Step 4
- Verify the service account exists in Google Cloud Console → IAM & Admin → Service Accounts

**Security Notes**

- **Never commit the JSON key file to your repository**
- Store the JSON file securely (password manager, encrypted drive)
- Consider the JSON key as sensitive as a password
- Service account keys don't expire, but you can revoke and create new ones if compromised
- Regularly audit service account permissions in Google Play Console
- Use different service accounts for different environments if needed (dev/staging/prod)

### iOS Variables

| Variable Name | Type | Description | How to Obtain |
|---------------|------|-------------|---------------|
| `IOS_CERTIFICATES_P12_BASE64` | Variable | Base64-encoded distribution certificate | Export from Keychain Access, then `base64 -i Certificates.p12` |
| `IOS_CERTIFICATES_PASSWORD` | Variable (Masked) | Password for the P12 certificate | Set when exporting from Keychain |
| `IOS_PROVISIONING_PROFILE_BASE64` | Variable | Base64-encoded provisioning profile | `base64 -i profile.mobileprovision` |
| `IOS_KEYCHAIN_PASSWORD` | Variable (Masked) | Temporary keychain password for CI | Any secure password (used only during CI) |
| `APP_STORE_CONNECT_API_KEY_BASE64` | Variable | Base64-encoded App Store Connect API key | Download from App Store Connect, then `base64 -i AuthKey_XXX.p8` |
| `APP_STORE_CONNECT_KEY_ID` | Variable | App Store Connect API Key ID | From App Store Connect → Users and Access → Keys |
| `APP_STORE_CONNECT_ISSUER_ID` | Variable | App Store Connect Issuer ID | From App Store Connect → Users and Access → Keys |
| `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` | Variable (Masked) | App-specific password | Generate from appleid.apple.com → Security → App-Specific Passwords |

#### Exporting iOS Distribution Certificate

1. Open Keychain Access on your Mac
2. Find your "Apple Distribution" certificate
3. Right-click → Export
4. Save as `.p12` file with a password
5. Convert to base64: `base64 -i Certificates.p12`

#### Getting Provisioning Profile

1. Go to Apple Developer Portal → Certificates, Identifiers & Profiles
2. Create/download App Store provisioning profile
3. Convert to base64: `base64 -i profile.mobileprovision`

#### Creating App Store Connect API Key

1. Go to App Store Connect → Users and Access → Keys
2. Click the + button to create a new key
3. Give it App Manager access
4. Download the `.p8` file
5. Note the Key ID and Issuer ID
6. Convert to base64: `base64 -i AuthKey_XXX.p8`

### Adding Variables to GitLab

1. Go to your GitLab project
2. Navigate to Settings → CI/CD
3. Expand the "Variables" section
4. Click "Add Variable"
5. Enter the key and value
6. For sensitive data, check "Mask variable"
7. For files, you can use "File" type or paste base64-encoded content as "Variable"
8. Click "Add variable"

## GitLab Runner Requirements

### For Android Builds
- Linux runner with Docker support (uses `cirrusci/flutter` image)
- No special configuration needed

### For iOS Builds
- macOS runner (required for iOS builds)
- Runner must be tagged with `macos`
- Xcode and command line tools installed
- CocoaPods installed

#### Setting up a macOS Runner

1. On a macOS machine:
```bash
# Download GitLab Runner
sudo curl --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-darwin-amd64

# Give it permissions to execute
sudo chmod +x /usr/local/bin/gitlab-runner

# Register the runner
gitlab-runner register
```

2. During registration:
   - Enter your GitLab instance URL
   - Enter the registration token (from Settings → CI/CD → Runners)
   - Enter a description (e.g., "macOS iOS Builder")
   - Enter tags: `macos`
   - Enter executor: `shell`

3. Install the runner as a service:
```bash
gitlab-runner install
gitlab-runner start
```

4. Ensure Xcode and tools are installed:
```bash
xcode-select --install
sudo gem install cocoapods
```

## Pipeline Triggers

### Automatic Triggers

**On Merge Requests:**
- Runs `analyze` and `test` jobs
- Builds debug Android APK

**On Push to main/master:**
- Runs all test jobs
- Builds release Android and iOS apps
- Deployment jobs become available (manual trigger required)

**On Tags:**
- Builds release versions
- Production deployment jobs become available

### Manual Triggers

All deployment jobs are set to `when: manual`, meaning they must be triggered manually from the GitLab UI:

1. Go to your project → CI/CD → Pipelines
2. Click on the pipeline you want to deploy
3. Find the deploy job you want to run
4. Click the play button (▶) next to the job

## Usage Examples

### Deploy to Android Internal Testing

```bash
# Make changes and commit
git add .
git commit -m "New feature"
git push origin main

# Then in GitLab:
# 1. Go to CI/CD → Pipelines
# 2. Click on the latest pipeline
# 3. In the "deploy" stage, click play on "deploy:android:internal"
```

### Deploy to Production (Android)

```bash
# Update version in pubspec.yaml first
git add .
git commit -m "Release v1.2.0"
git tag v1.2.0
git push origin main --tags

# Then in GitLab:
# 1. Go to CI/CD → Pipelines
# 2. Find the pipeline for tag v1.2.0
# 3. Click play on "deploy:android:production"
```

### Deploy to TestFlight (iOS)

```bash
git add .
git commit -m "iOS beta release"
git push origin main

# Then in GitLab:
# 1. Go to CI/CD → Pipelines
# 2. Click on the latest pipeline
# 3. Click play on "deploy:ios:testflight"
```

### Deploy to App Store (iOS)

```bash
# Update version in pubspec.yaml
git add .
git commit -m "Release v1.2.0"
git tag v1.2.0
git push origin main --tags

# Then in GitLab:
# 1. Go to CI/CD → Pipelines
# 2. Find the pipeline for tag v1.2.0
# 3. Click play on "deploy:ios:appstore"
```

## Version Management

Before releasing, update the version in `pubspec.yaml`:

```yaml
version: 1.2.0+3
```

- `1.2.0` = Version name (displayed to users)
- `3` = Build number (must increment with each release)

## Monitoring Deployments

### GitLab Pipelines

1. Go to your project → CI/CD → Pipelines
2. View pipeline status and job logs
3. Click on a job to see detailed output
4. Download build artifacts from job pages

### Artifacts

Build artifacts are automatically saved:
- **Debug APK**: Available for 7 days
- **Release AAB/APK**: Available for 30 days
- **iOS builds**: Available for 7 days
- **Coverage reports**: Available for 30 days

To download artifacts:
1. Go to CI/CD → Pipelines
2. Click on the pipeline
3. Click on the job with artifacts
4. Click "Browse" or "Download" button

### Coverage Reports

Test coverage is automatically tracked:
- Coverage percentage shown in pipeline view
- Coverage reports available as artifacts
- View detailed HTML coverage report in artifacts

## Troubleshooting

### Android Build Fails

**Issue**: Keystore or signing error
- Verify `ANDROID_KEYSTORE_BASE64` is correctly encoded (no line breaks in base64)
- Use `base64 -w 0` on Linux to ensure no line wrapping
- Check that passwords match your keystore
- Ensure `upload-keystore.jks` file name matches in variables

**Issue**: Google Play API error
- Verify service account JSON is correct and base64-encoded properly
- Check service account has proper permissions in Play Console
- Ensure package name matches in Play Console

**Issue**: Flutter not found
- Check if Flutter is being cloned correctly in `.flutter_setup`
- Verify network connectivity in runner
- Try using a specific Flutter version

### iOS Build Fails

**Issue**: No macOS runner available
- Ensure you have registered a macOS runner
- Verify the runner is tagged with `macos`
- Check runner is active: `gitlab-runner verify`

**Issue**: Code signing error
- Verify certificate and provisioning profile are valid
- Check that bundle identifier matches provisioning profile
- Ensure certificate hasn't expired
- Verify keychain password is correct

**Issue**: CocoaPods error
- Run `cd ios && pod install` locally first to verify
- Check CocoaPods is installed on macOS runner
- Update CocoaPods: `sudo gem install cocoapods`

### General Issues

**Issue**: Tests fail
- Run tests locally first: `flutter test`
- Check test coverage and fix failing tests
- Review test output in job logs

**Issue**: Job timeout
- Default timeout is 1 hour
- Increase in Settings → CI/CD → General pipelines → Timeout
- Optimize build by using cache effectively

**Issue**: Variables not recognized
- Ensure variables are not protected if running on non-protected branches
- Check variable names match exactly (case-sensitive)
- Verify masked variables don't contain special characters that cause masking issues

## Security Best Practices

1. **Use masked variables for sensitive data**
   - Password fields should be masked
   - API keys should be masked
   - Never log sensitive variables

2. **Protect variables for production**
   - Mark production variables as "Protected"
   - Only protected branches can access protected variables

3. **Rotate credentials regularly**
   - Update service account keys annually
   - Rotate API keys and passwords
   - Update certificates before expiration

4. **Use minimal permissions**
   - Service accounts should have only necessary permissions
   - API keys should have appropriate access levels

5. **Monitor pipeline runs**
   - Review failed runs for security issues
   - Check for unauthorized access attempts
   - Enable email notifications for failed pipelines

6. **Clean up artifacts**
   - Jobs automatically clean up sensitive files
   - Artifacts expire automatically (7-30 days)
   - Manually delete old artifacts if needed

## Customization

### Changing Flutter Version

Edit the version in `.gitlab-ci.yml`:

```yaml
variables:
  FLUTTER_VERSION: "3.24.5"  # Change this
```

### Adding Pre-deployment Tests

Add integration tests to the pipeline:

```yaml
integration_test:
  stage: test
  extends:
    - .cache_template
    - .flutter_setup
  script:
    - flutter test integration_test
```

### Customizing Deployment Tracks

Modify deployment conditions:

```yaml
deploy:android:alpha:
  stage: deploy
  # ... same as deploy:android:beta
  script:
    - bundle exec fastlane supply --track alpha --aab ...
  only:
    - /^.*-alpha$/  # Only for tags ending with -alpha
```

### Auto-deployment (Remove Manual Trigger)

To enable automatic deployment, remove `when: manual`:

```yaml
deploy:android:internal:
  stage: deploy
  # Remove this line:
  # when: manual
```

**Warning**: This will deploy automatically on every push to main/master.

## CI/CD Pipeline Diagram

```
┌─────────────────────────────────────────────────────┐
│                    TEST STAGE                       │
├─────────────────────────────────────────────────────┤
│  analyze              test                          │
│  (lint & format)      (unit tests + coverage)       │
└─────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                   BUILD STAGE                       │
├──────────────────────┬──────────────────────────────┤
│  Android             │  iOS                         │
│  - debug APK         │  - release (no codesign)     │
│  - release AAB       │                              │
│  - release APK       │                              │
└──────────────────────┴──────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────┐
│                  DEPLOY STAGE                       │
│                  (Manual Trigger)                   │
├──────────────────────┬──────────────────────────────┤
│  Android             │  iOS                         │
│  - internal          │  - testflight                │
│  - beta              │  - appstore                  │
│  - production        │                              │
└──────────────────────┴──────────────────────────────┘
```

## Additional Resources

- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [Fastlane Documentation](https://docs.fastlane.tools/)
- [Flutter CI/CD Guide](https://docs.flutter.dev/deployment/cd)
- [Google Play Publishing Guide](https://developer.android.com/studio/publish)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [GitLab Runner Documentation](https://docs.gitlab.com/runner/)

## Support

For issues with:
- **GitLab CI/CD**: Check job logs in Pipelines view
- **GitLab Runner**: Run `gitlab-runner verify` and check runner logs
- **Fastlane**: Review Fastlane documentation and job output
- **Google Play**: Contact Google Play support
- **App Store**: Contact Apple Developer support
