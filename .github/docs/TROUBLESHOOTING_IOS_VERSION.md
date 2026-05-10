# 🔧 Troubleshooting iOS Version Issues

## Issue: IPA Bundle Version Doesn't Match Configuration

### Symptoms
```
=== Marketing Version Information ===
Configured Version Name: 5.12.1
Configured Build Number: 357
IPA Bundle Version: 355.1          ← Wrong! Should be 357
IPA Bundle Short Version: 5.12.1   ← Correct
```

### Root Cause
The xcodebuild command was executed **without** the `CURRENT_PROJECT_VERSION` flag, causing it to use the version stored in the Xcode project file instead of the version from `version-config.json`.

### Why This Happens

#### Understanding the Build Flow

```
1. version-config.json has: buildNumber: 357
   ↓
2. Flutter build sets: --build-number=357
   ↓
3. xcodebuild archive runs WITHOUT version flags  ← Problem here!
   ↓
4. Xcode uses project file value: 355.1
   ↓
5. IPA has wrong version: 355.1
```

#### The xcpretty Fallback Pattern

Your workflow has TWO xcodebuild commands:

```bash
# Command 1: With xcpretty (pretty output)
xcodebuild archive \
  CURRENT_PROJECT_VERSION=357 \
  MARKETING_VERSION=5.12.1 \
  | xcpretty 

|| # If command 1 fails, run command 2

# Command 2: Fallback (raw output)
xcodebuild archive \
  # Missing version flags! ← This is the problem
```

**If xcpretty is not installed or fails, the fallback command runs without version flags!**

### Solution

**Both xcodebuild commands MUST have the version flags:**

```yaml
xcodebuild archive \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -configuration Release \
  -archivePath "$ARCHIVE_PATH" \
  CODE_SIGN_STYLE=Manual \
  DEVELOPMENT_TEAM=6XMSL7CZ8U \
  CODE_SIGN_IDENTITY="iPhone Distribution" \
  CURRENT_PROJECT_VERSION=${{ steps.version.outputs.BUILD_NUMBER }} \
  MARKETING_VERSION=${{ steps.version.outputs.VERSION_NAME }} \
  | xcpretty || xcodebuild archive \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -configuration Release \
  -archivePath "$ARCHIVE_PATH" \
  CODE_SIGN_STYLE=Manual \
  DEVELOPMENT_TEAM=6XMSL7CZ8U \
  CODE_SIGN_IDENTITY="iPhone Distribution" \
  CURRENT_PROJECT_VERSION=${{ steps.version.outputs.BUILD_NUMBER }} \  # ← Must be here too!
  MARKETING_VERSION=${{ steps.version.outputs.VERSION_NAME }}           # ← Must be here too!
```

### Verification Steps

#### 1. Check Workflow Logs
Look for the version echo statement:
```
Setting version: MARKETING_VERSION=5.12.1, CURRENT_PROJECT_VERSION=357
```

#### 2. Check xcodebuild Command
Verify BOTH commands have the flags:
```bash
# First command
CURRENT_PROJECT_VERSION=357 MARKETING_VERSION=5.12.1 | xcpretty

# Fallback command
CURRENT_PROJECT_VERSION=357 MARKETING_VERSION=5.12.1  # ← Must be here!
```

#### 3. Check IPA Bundle Info
Your workflow already has this verification:
```bash
=== IPA Bundle Information ===
Bundle Version (CFBundleVersion): 357         ← Should match config
Bundle Short Version (CFBundleShortVersionString): 5.12.1
```

### Quick Fix Checklist

- [ ] Both xcodebuild commands have `CURRENT_PROJECT_VERSION`
- [ ] Both xcodebuild commands have `MARKETING_VERSION`
- [ ] Version loaded correctly from config (`steps.version.outputs.BUILD_NUMBER`)
- [ ] IPA verification shows correct version
- [ ] Commit and push changes
- [ ] Run workflow again

---

## Other Common Version Issues

### Issue: Version Doesn't Update After Config Change

**Symptoms:**
```
Config says: 357
IPA says: 356
```

**Causes:**
1. Changes not committed
2. Workflow using old branch/commit
3. Build cache not cleared

**Solutions:**
```bash
# 1. Verify config is committed
git status
git add .github/config/version-config.json
git commit -m "chore: bump version to 357"
git push

# 2. Trigger new build (don't use cached build)

# 3. Clean build (if needed)
flutter clean
rm -rf ios/build
```

### Issue: Flutter Build Version vs Xcode Archive Version

**Understanding:**
- `flutter build ios --build-number=357` sets the version in Flutter's build
- `xcodebuild archive CURRENT_PROJECT_VERSION=357` **overrides** it during archive

**Why xcodebuild flags are required:**
Xcode archive creation can override Flutter's version settings. To guarantee the version, we must set it explicitly in xcodebuild.

**Best Practice:**
Always set version in BOTH places:
```yaml
# Flutter build
flutter build ios \
  --build-name=${{ steps.version.outputs.VERSION_NAME }} \
  --build-number=${{ steps.version.outputs.BUILD_NUMBER }}

# Xcode archive
xcodebuild archive \
  CURRENT_PROJECT_VERSION=${{ steps.version.outputs.BUILD_NUMBER }} \
  MARKETING_VERSION=${{ steps.version.outputs.VERSION_NAME }}
```

### Issue: Build Number Format Error

**Symptoms:**
```
Error: CFBundleVersion must be numeric
```

**Cause:**
Build number contains non-numeric characters (except dots)

**Valid formats:**
- ✅ `357`
- ✅ `357.1`
- ✅ `357.1.2`
- ❌ `357-dev`
- ❌ `v357`
- ❌ `357a`

**Solution:**
```json
{
  "ios": {
    "dev": {
      "buildNumber": "357.1"  // ✅ Valid
      // "buildNumber": "357-dev"  // ❌ Invalid
    }
  }
}
```

### Issue: App Store Rejection - Version Already Exists

**Symptoms:**
```
Error: Version 5.12.1 (357) already exists
```

**Cause:**
Build number must be higher than previously submitted builds

**Solution:**
```bash
# Check current version in App Store Connect
# Then set higher build number
./version-manager.sh ios prod set 5.12.1 358
```

### Issue: Different Versions in Different Targets

**Symptoms:**
Main app has version 357, but widget extension has 355.1

**Cause:**
Extensions and app clips have separate Info.plist files

**Solution:**
Ensure xcodebuild sets version for all targets:
```bash
# This sets version for all targets in the workspace
xcodebuild archive \
  CURRENT_PROJECT_VERSION=357 \
  MARKETING_VERSION=5.12.1
```

---

## Debugging Guide

### Step 1: Check Version Config
```bash
cat .github/config/version-config.json | jq '.ios.dev'
```

Expected output:
```json
{
  "versionName": "5.12.1",
  "buildNumber": "357",
  "releaseNotes": {...}
}
```

### Step 2: Check Workflow Version Loading
Look in workflow logs:
```
=== Version Information ===
Version Name: 5.12.1
Build Number: 357
```

### Step 3: Check xcodebuild Command
Look in workflow logs for:
```
xcodebuild archive \
  CURRENT_PROJECT_VERSION=357 \
  MARKETING_VERSION=5.12.1
```

Verify BOTH commands (with and without xcpretty) have these flags.

### Step 4: Check IPA Content
Look in workflow logs for:
```
=== IPA Bundle Information ===
Bundle Version (CFBundleVersion): 357
Bundle Short Version (CFBundleShortVersionString): 5.12.1
```

### Step 5: Manual Verification (Local)
```bash
# Download IPA from artifacts
# Extract it
unzip vinaresearch.ipa -d extracted

# Check version
/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" \
  extracted/Payload/*.app/Info.plist

/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" \
  extracted/Payload/*.app/Info.plist
```

---

## Prevention Checklist

### For Every Version Update:

- [ ] Update `version-config.json`
- [ ] Commit and push changes
- [ ] Verify workflow loads correct version
- [ ] Check xcodebuild has version flags
- [ ] Verify IPA has correct version
- [ ] Test in TestFlight before production

### For Workflow Changes:

- [ ] Both xcodebuild commands have version flags
- [ ] Version echoed before build
- [ ] IPA verification step present
- [ ] Test with a build before merging

### For Config Changes:

- [ ] Valid version format (X.Y.Z)
- [ ] Valid build number format (numeric/decimal)
- [ ] Build number higher than previous
- [ ] JSON is valid (`jq empty config.json`)

---

## Quick Reference

### Version Variables
```yaml
${{ steps.version.outputs.VERSION_NAME }}  # From versionName
${{ steps.version.outputs.BUILD_NUMBER }}  # From buildNumber
```

### xcodebuild Flags
```bash
MARKETING_VERSION=5.12.1              # User-visible version
CURRENT_PROJECT_VERSION=357           # Build number
```

### Info.plist Keys
```xml
CFBundleShortVersionString = 5.12.1   # From MARKETING_VERSION
CFBundleVersion = 357                 # From CURRENT_PROJECT_VERSION
```

---

## When to Ask for Help

If after following this guide:
- ✅ Both xcodebuild commands have version flags
- ✅ Workflow logs show correct version loading
- ✅ But IPA still has wrong version

Then check:
1. Xcode project settings (Info.plist might be overriding)
2. Build configuration (Debug vs Release)
3. Workspace settings
4. Scheme settings

---

## Summary

**The Fix:**
```yaml
# ✅ BOTH commands need version flags
xcodebuild ... CURRENT_PROJECT_VERSION=X MARKETING_VERSION=Y | xcpretty || \
xcodebuild ... CURRENT_PROJECT_VERSION=X MARKETING_VERSION=Y
```

**Why:**
- xcodebuild can override Flutter's version settings
- Fallback command must also have the flags
- This guarantees version consistency

**Verification:**
```bash
# Check IPA after build
unzip -q vinaresearch.ipa -d check
/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" check/Payload/*.app/Info.plist
# Should output: 357 (your configured version)
```

---

**Last Updated:** 2024-12-09  
**Status:** ✅ Issue Resolved

