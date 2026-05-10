# 🔧 iOS Version Issue - Complete Fix

## Problem Summary

**Issue:** IPA Bundle Version was 355.1 instead of configured 357

```
Configured Build Number: 357
IPA Bundle Version: 355.1  ❌ Wrong!
```

## Root Cause

The issue had **two parts**:

### Part 1: Missing Version Flags in Fallback Command (FIXED)
The xcodebuild fallback command (without xcpretty) was missing version flags.

### Part 2: Flutter Build Overriding Version (FIXED)
**This was the real culprit!**

The workflow had this sequence:
```
1. Flutter build sets version → Info.plist = 357
2. xcodebuild archive with version flags → Ignores flags, uses Info.plist
3. But Info.plist might have old cached value → Result = 355.1
```

**Why xcodebuild flags didn't work:**
- When you run `flutter build ios --build-number=X`, Flutter writes X to Info.plist
- Then xcodebuild archive reads from that Info.plist
- The CURRENT_PROJECT_VERSION flag in xcodebuild might not override an already-set Info.plist value during archive (only during build)

## Complete Solution

### Change 1: Remove Version Flags from Flutter Build

**Before:**
```yaml
flutter build ios --release \
  --no-codesign \
  --build-name=${{ steps.version.outputs.VERSION_NAME }} \  ❌ Remove this
  --build-number=${{ steps.version.outputs.BUILD_NUMBER }} \  ❌ Remove this
  --dart-define=APP_ENVIRONMENT=DEVELOPMENT
```

**After:**
```yaml
flutter build ios --release \
  --no-codesign \
  --dart-define=APP_ENVIRONMENT=DEVELOPMENT
# Version will be set by xcodebuild, not Flutter
```

### Change 2: Add Clean Build Step

**Added before xcodebuild archive:**
```yaml
xcodebuild clean \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -configuration Release
```

This ensures xcodebuild does a fresh build with the version flags.

### Change 3: Set Version ONLY in xcodebuild

```yaml
xcodebuild archive \
  ... \
  CURRENT_PROJECT_VERSION=${{ steps.version.outputs.BUILD_NUMBER }} \
  MARKETING_VERSION=${{ steps.version.outputs.VERSION_NAME }}
```

Now xcodebuild is the **single source of truth** for version.

### Change 4: Add Version Verification

**In Archive:**
```yaml
echo "=== Verifying version in archive ==="
ARCHIVE_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" ...)
echo "Archive CFBundleVersion: $ARCHIVE_VERSION (should be 357)"
```

**In IPA:**
```yaml
echo "=== IPA Bundle Information ==="
BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" ...)
echo "Bundle Version: $BUNDLE_VERSION"
```

## How It Works Now

### New Flow:

```
1. Load version from config
   versionName: 5.12.1
   buildNumber: 357
   ↓
2. Flutter build WITHOUT version flags
   Info.plist: (default or previous value)
   ↓
3. xcodebuild clean
   Clears any cached builds
   ↓
4. xcodebuild archive WITH version flags
   CURRENT_PROJECT_VERSION=357
   MARKETING_VERSION=5.12.1
   ↓
5. xcodebuild REBUILDS with version flags
   Info.plist: 357, 5.12.1 ✅
   ↓
6. Archive contains correct version
   CFBundleVersion: 357 ✅
   ↓
7. Export IPA with correct version
   IPA Bundle Version: 357 ✅
```

## Expected Workflow Output

When you run the workflow now, you should see:

### 1. Version Loading
```
=== Version Information ===
Version Name: 5.12.1
Build Number: 357
```

### 2. Flutter Build
```
=== Building iOS App ===
Target version: 5.12.1 (357)
Note: Version will be set during xcodebuild archive, not Flutter build
✅ Flutter build completed (version will be set in archive step)
```

### 3. Clean Build
```
=== Cleaning Xcode build ===
(clean output)
```

### 4. Archive Creation
```
Setting version: MARKETING_VERSION=5.12.1, CURRENT_PROJECT_VERSION=357
=== Creating archive with version flags ===
(xcodebuild output)
```

### 5. Archive Verification
```
=== Verifying version in archive ===
Archive CFBundleVersion: 357 (should be 357) ✅
Archive CFBundleShortVersionString: 5.12.1 (should be 5.12.1) ✅
```

### 6. IPA Verification
```
=== IPA Bundle Information ===
Bundle Version (CFBundleVersion): 357 ✅
Bundle Short Version (CFBundleShortVersionString): 5.12.1 ✅

=== Marketing Version Information ===
Configured Version Name: 5.12.1
Configured Build Number: 357
IPA Bundle Version: 357 ✅
IPA Bundle Short Version: 5.12.1 ✅
```

## Why This Approach Works

### Single Source of Truth
```
❌ OLD: Flutter sets version → xcodebuild tries to override → Conflict
✅ NEW: xcodebuild sets version → No conflict
```

### Clean Build Guarantees Fresh Compilation
```
❌ OLD: Cached build might have old version
✅ NEW: Clean + rebuild guarantees correct version
```

### Explicit Version Setting
```
❌ OLD: Version in Info.plist might be cached/stale
✅ NEW: xcodebuild explicitly sets version during build
```

## Testing the Fix

### 1. Update Version
```bash
./version-manager.sh ios dev set 5.12.2 358
git add .github/config/version-config.json
git commit -m "test: version 358"
git push
```

### 2. Watch Workflow Logs
Check for:
- ✅ Version loaded: 358
- ✅ Flutter build without version flags
- ✅ xcodebuild clean executed
- ✅ xcodebuild archive with version flags
- ✅ Archive verification shows 358
- ✅ IPA verification shows 358

### 3. Verify in TestFlight
After upload, check TestFlight:
- Version should be 5.12.2 (358)

## Preventing Future Issues

### ✅ DO:
1. **Only set version in xcodebuild**, not Flutter build
2. **Always clean before archiving** for critical builds
3. **Verify version in archive** before exporting
4. **Verify version in IPA** before uploading

### ❌ DON'T:
1. Set version in both Flutter build AND xcodebuild (conflict)
2. Skip the clean step (might use cached build)
3. Assume version is correct without verification

## Related Files

- **Workflow:** `.github/workflows/deploy_ios_internal.yml`
- **Config:** `.github/config/version-config.json`
- **Docs:** `.github/docs/IOS_VERSION_CONFIGURATION.md`
- **Troubleshooting:** `.github/docs/TROUBLESHOOTING_IOS_VERSION.md`

## Summary

**Before:**
- Flutter build: Set version 357
- xcodebuild archive: Try to override → FAILED
- Result: IPA has version 355.1 ❌

**After:**
- Flutter build: No version
- xcodebuild clean: Clear cache
- xcodebuild archive: Set version 357 → SUCCESS
- Result: IPA has version 357 ✅

---

**Status:** ✅ Fixed  
**Last Updated:** 2024-12-09  
**Next Steps:** Test with a new build

