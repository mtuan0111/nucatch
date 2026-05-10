# 📱 iOS Version Configuration Guide

## Overview

The iOS build process now uses version information from `version-config.json` during the Xcode archive creation. This ensures the IPA file contains the correct version and build number.

## Version Variables

### MARKETING_VERSION
- **What it is:** The user-visible version number (e.g., "5.12.1")
- **Maps to:** `CFBundleShortVersionString` in Info.plist
- **Loaded from:** `.ios.dev.versionName` or `.ios.prod.versionName` in version-config.json
- **Visible to users:** Yes (in App Store, TestFlight, and Settings)

### CURRENT_PROJECT_VERSION
- **What it is:** The build number (e.g., "355.4" or "355")
- **Maps to:** `CFBundleVersion` in Info.plist
- **Loaded from:** `.ios.dev.buildNumber` or `.ios.prod.buildNumber` in version-config.json
- **Visible to users:** Sometimes (in TestFlight and Settings)

## How It Works

### 1. Version Loading
The workflow loads version information from the config file:

```yaml
- name: 🔢 Load version configuration
  id: version
  run: |
    VERSION_NAME=$(jq -r '.ios.dev.versionName' .github/config/version-config.json)
    BUILD_NUMBER=$(jq -r '.ios.dev.buildNumber' .github/config/version-config.json)
    echo "VERSION_NAME=$VERSION_NAME" >> $GITHUB_OUTPUT
    echo "BUILD_NUMBER=$BUILD_NUMBER" >> $GITHUB_OUTPUT
```

### 2. Flutter Build
The Flutter build step uses these versions:

```yaml
- name: 🏗️ Build iOS app
  run: |
    flutter build ios --release \
      --no-codesign \
      --build-name=${{ steps.version.outputs.VERSION_NAME }} \
      --build-number=${{ steps.version.outputs.BUILD_NUMBER }}
```

### 3. Xcode Archive Creation
The xcodebuild command explicitly sets both version variables:

```yaml
- name: 📦 Create archive and export IPA
  run: |
    xcodebuild archive \
      -workspace ios/Runner.xcworkspace \
      -scheme Runner \
      -configuration Release \
      -archivePath "$ARCHIVE_PATH" \
      -allowProvisioningUpdates \
      CODE_SIGN_STYLE=Manual \
      DEVELOPMENT_TEAM="$IOS_TEAM_ID" \
      CODE_SIGN_IDENTITY="iPhone Distribution" \
      CURRENT_PROJECT_VERSION=${{ steps.version.outputs.BUILD_NUMBER }} \
      MARKETING_VERSION=${{ steps.version.outputs.VERSION_NAME }}
```

## Configuration Example

### version-config.json
```json
{
  "ios": {
    "dev": {
      "versionName": "5.12.1",
      "buildNumber": "355.4",
      "releaseNotes": {
        "en-US": "Bug fixes and improvements"
      }
    },
    "prod": {
      "versionName": "5.12.1",
      "buildNumber": "355",
      "releaseNotes": {
        "en-US": "Bug fixes and improvements"
      }
    }
  }
}
```

### Resulting IPA
- **CFBundleShortVersionString:** 5.12.1
- **CFBundleVersion:** 355.4 (or 355 for prod)

## Why This Matters

### Before
- Version was set during `flutter build ios`
- Sometimes Info.plist had stale values
- Xcode might use cached version numbers
- Risk of version mismatch between Flutter and native

### After
- Version explicitly set at archive time
- Guaranteed to match version-config.json
- No cached version issues
- Consistent across all build artifacts

## Verification

### Check IPA Version After Build
```bash
# Extract IPA
unzip -q build/ios/ipa/vinaresearch.ipa -d build/ios/ipa/extracted

# Check version in Info.plist
/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" \
  build/ios/ipa/extracted/Payload/*.app/Info.plist

# Check build number in Info.plist
/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" \
  build/ios/ipa/extracted/Payload/*.app/Info.plist
```

### Workflow Output
The workflow logs will show:
```
Setting version: MARKETING_VERSION=5.12.1, CURRENT_PROJECT_VERSION=355.4
```

## Common Scenarios

### Scenario 1: Development Build
```json
{
  "ios": {
    "dev": {
      "versionName": "5.12.1",
      "buildNumber": "355.4"
    }
  }
}
```

**Result:**
- App shows: "5.12.1 (355.4)" in Settings
- TestFlight shows: Version 5.12.1 (355.4)

### Scenario 2: Production Build
```json
{
  "ios": {
    "prod": {
      "versionName": "5.12.1",
      "buildNumber": "355"
    }
  }
}
```

**Result:**
- App shows: "5.12.1 (355)" in Settings
- App Store shows: Version 5.12.1

### Scenario 3: Version Bump
```bash
# Bump version
./version-manager.sh ios dev bump-patch

# Version changes from 5.12.1 (355.4) to 5.12.2 (356)
```

**Result:**
- Next build will have version 5.12.2 (356)
- Automatically applied during xcodebuild

## App Store Requirements

### Version Number (MARKETING_VERSION)
- Must be in format: `X.Y.Z` or `X.Y`
- Examples: `5.12.1`, `1.0`, `2.3.4`
- Must increase for new releases (or stay same with higher build number)

### Build Number (CURRENT_PROJECT_VERSION)
- Can be integer or decimal: `355`, `355.4`, `100.1.5`
- **Must always increase** for new submissions
- TestFlight requires unique build numbers

## Troubleshooting

### Issue: Version not updating in IPA

**Check 1: Version loaded correctly?**
```yaml
# Look for this in workflow logs
Version Name: 5.12.1
Build Number: 355.4
```

**Check 2: Version passed to xcodebuild?**
```yaml
# Look for this in workflow logs
Setting version: MARKETING_VERSION=5.12.1, CURRENT_PROJECT_VERSION=355.4
```

**Check 3: Verify IPA content**
```bash
# Extract and check
unzip -q vinaresearch.ipa -d extracted
/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" \
  extracted/Payload/*.app/Info.plist
```

### Issue: "Version must be higher than previous"

**Solution:** Increase the build number
```bash
./version-manager.sh ios prod set 5.12.1 356
```

### Issue: Different version in TestFlight vs. Config

**Cause:** Build was created before version update

**Solution:** 
1. Update version in config
2. Commit changes
3. Push to trigger new build
4. New build will have updated version

## Best Practices

### 1. Always Update Config First
```bash
# Before building
./version-manager.sh ios dev bump-patch
git add .github/config/version-config.json
git commit -m "chore: bump iOS version"
git push
```

### 2. Use Semantic Versioning
- **MAJOR:** Breaking changes (5.0.0)
- **MINOR:** New features (5.12.0)
- **PATCH:** Bug fixes (5.12.1)

### 3. Build Numbers Must Increase
```bash
# Get current build number
./version-manager.sh ios prod get
# Output: buildNumber: 355

# Set higher build number
./version-manager.sh ios prod set 5.12.2 356
```

### 4. Separate Dev and Prod
- **Dev:** Can have frequent builds (355.1, 355.2, 355.3)
- **Prod:** Clean build numbers (355, 356, 357)

### 5. Verify Before Uploading
```bash
# After build, check the IPA
unzip -l build/ios/ipa/vinaresearch.ipa | grep Info.plist
```

## Advanced: Manual Xcode Build

If building manually with Xcode:

```bash
# Set version in command line
xcodebuild archive \
  -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -archivePath build/Runner.xcarchive \
  CURRENT_PROJECT_VERSION=355.4 \
  MARKETING_VERSION=5.12.1
```

## Summary

✅ **Versions loaded** from version-config.json  
✅ **Applied to Flutter** build via `--build-name` and `--build-number`  
✅ **Applied to Xcode** archive via `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION`  
✅ **Verified in IPA** via Info.plist  
✅ **Uploaded to TestFlight** with correct version  

This ensures **complete version consistency** from configuration to final IPA! 🎯

## Related Documentation

- [Version Management Guide](VERSION_MANAGEMENT.md)
- [Quick Start Guide](QUICK_START_VERSION_MANAGEMENT.md)
- [Multi-Language Release Notes](MULTI_LANGUAGE_RELEASE_NOTES.md)

---

**Last Updated:** 2024-12-09  
**Status:** ✅ Production Ready

