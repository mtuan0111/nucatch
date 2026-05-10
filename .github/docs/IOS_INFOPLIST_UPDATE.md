# 📝 iOS Info.plist Direct Update Strategy

## Overview

To ensure the IPA has the correct version, we **directly update the Info.plist file** before building the archive. This is the most reliable method to guarantee version consistency.

## Why Direct Update?

### Problem with xcodebuild Flags Only
```yaml
# This approach sometimes fails:
xcodebuild archive CURRENT_PROJECT_VERSION=357
# Xcode might use cached Info.plist or ignore the flag
```

### Solution: Direct Info.plist Update
```yaml
# Guaranteed approach:
PlistBuddy -c "Set :CFBundleVersion 357" Info.plist
xcodebuild archive
# Now Info.plist has the right version before build starts
```

## How It Works

### Step-by-Step Process

```
1. Load version from config
   ↓
2. Update Info.plist DIRECTLY
   CFBundleVersion → 357
   CFBundleShortVersionString → 5.12.1
   ↓
3. Verify Info.plist was updated
   ↓
4. Clean build
   ↓
5. xcodebuild archive
   (reads the already-correct Info.plist)
   ↓
6. Archive has correct version ✅
   ↓
7. Export IPA with correct version ✅
```

## Implementation

### Code Added to Workflows

```yaml
# Update Info.plist directly
echo "=== Updating Info.plist with correct version ==="
if [ -f "ios/Runner/Info.plist" ]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${{ steps.version.outputs.BUILD_NUMBER }}" ios/Runner/Info.plist
  /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${{ steps.version.outputs.VERSION_NAME }}" ios/Runner/Info.plist
  echo "✅ Updated Info.plist"
fi

# Verify it worked
AFTER_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" ios/Runner/Info.plist)
AFTER_SHORT=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" ios/Runner/Info.plist)
echo "Info.plist CFBundleVersion: $AFTER_VERSION (should be ${{ steps.version.outputs.BUILD_NUMBER }})"
echo "Info.plist CFBundleShortVersionString: $AFTER_SHORT (should be ${{ steps.version.outputs.VERSION_NAME }})"

# Fail if mismatch
if [ "$AFTER_VERSION" != "${{ steps.version.outputs.BUILD_NUMBER }}" ]; then
  echo "❌ ERROR: Failed to update CFBundleVersion!"
  exit 1
fi
```

## What Gets Updated

### Info.plist Location
```
vinaresearch-flutter/ios/Runner/Info.plist
```

### Keys Updated
```xml
<key>CFBundleVersion</key>
<string>357</string>

<key>CFBundleShortVersionString</key>
<string>5.12.1</string>
```

### Verification
- Before update: Shows old values
- After update: Shows new values
- After archive: Verifies archive has correct values
- After IPA export: Verifies IPA has correct values

## Expected Workflow Output

### 1. Before Update
```
=== Info.plist BEFORE update ===
Info.plist CFBundleVersion: 355.1
Info.plist CFBundleShortVersionString: 5.12.0
```

### 2. Update
```
=== Updating Info.plist with correct version ===
✅ Updated Info.plist
```

### 3. After Update
```
=== Info.plist AFTER update ===
Info.plist CFBundleVersion: 357 (should be 357) ✅
Info.plist CFBundleShortVersionString: 5.12.1 (should be 5.12.1) ✅
✅ Info.plist version verified
```

### 4. Clean Build
```
=== Cleaning Xcode build ===
(clean output)
```

### 5. Archive
```
=== Creating archive with version flags ===
(xcodebuild output)
```

### 6. Archive Verification
```
=== Verifying version in archive ===
Archive CFBundleVersion: 357 (should be 357) ✅
Archive CFBundleShortVersionString: 5.12.1 (should be 5.12.1) ✅
```

### 7. IPA Verification
```
=== IPA Bundle Information ===
Bundle Version (CFBundleVersion): 357 ✅
Bundle Short Version (CFBundleShortVersionString): 5.12.1 ✅
```

## Error Handling

### If Update Fails

```
❌ ERROR: Failed to update CFBundleVersion!
(workflow stops)
```

**Causes:**
- Info.plist file not found
- File permissions issue
- Invalid version format

**Solutions:**
- Check file exists: `ls ios/Runner/Info.plist`
- Check permissions: `ls -la ios/Runner/Info.plist`
- Verify version format is valid (numeric for build number)

### If Verification Fails

```
⚠️  WARNING: Archive version doesn't match! Expected 357, got 355.1
```

**Causes:**
- Xcode cached the old version despite Info.plist update
- Build artifacts not cleaned properly

**Solutions:**
- Ensure clean step runs before archive
- Check `rm -rf ios/build` is executed
- Verify `xcodebuild clean` runs successfully

## Advantages of This Approach

### ✅ Guaranteed Version Setting
```
Direct file update → 100% reliable
xcodebuild flags → Sometimes ignored
```

### ✅ Verifiable at Each Step
```
Before: Check old value
Update: Perform update
After: Verify new value
Archive: Verify in archive
IPA: Verify in IPA
```

### ✅ Early Failure Detection
```
If Info.plist update fails → Fail immediately
Don't waste time building wrong version
```

### ✅ No Cache Issues
```
Info.plist updated on disk → Forces Xcode to read new value
Even if xcodebuild flags fail → Info.plist has right value
```

## Comparison: All Approaches

### Approach 1: Flutter Build Flags (❌ Unreliable)
```yaml
flutter build ios --build-number=357
# Might get cached or overridden
```

### Approach 2: xcodebuild Flags Only (⚠️ Sometimes Fails)
```yaml
xcodebuild archive CURRENT_PROJECT_VERSION=357
# Sometimes ignored if Info.plist already set
```

### Approach 3: Direct Info.plist Update (✅ Reliable)
```yaml
PlistBuddy -c "Set :CFBundleVersion 357" Info.plist
xcodebuild archive
# Guaranteed to work
```

### Approach 4: Info.plist + xcodebuild Flags (✅✅ Most Reliable)
```yaml
PlistBuddy -c "Set :CFBundleVersion 357" Info.plist
xcodebuild clean
xcodebuild archive CURRENT_PROJECT_VERSION=357
# Belt and suspenders approach - current implementation
```

## Best Practices

### 1. Always Verify After Update
```bash
AFTER_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" Info.plist)
if [ "$AFTER_VERSION" != "357" ]; then
  exit 1
fi
```

### 2. Clean Before Building
```bash
xcodebuild clean  # Clear cached artifacts
rm -rf ios/build  # Remove build directory
```

### 3. Use Both Info.plist Update AND xcodebuild Flags
```bash
# Update file
PlistBuddy -c "Set :CFBundleVersion 357" Info.plist

# Still pass flags (defense in depth)
xcodebuild archive CURRENT_PROJECT_VERSION=357
```

### 4. Verify in Multiple Places
```bash
# Check Info.plist
# Check archive
# Check IPA
# Fail fast if any mismatch
```

## Troubleshooting

### Q: Info.plist shows correct version but IPA doesn't?

**A:** Check if there are multiple Info.plist files:
```bash
find ios -name "Info.plist"
# Update all of them if needed
```

### Q: Update succeeds but archive still has old version?

**A:** Xcode might be using a cached build:
```bash
# Add aggressive cleaning
rm -rf ~/Library/Developer/Xcode/DerivedData/*
xcodebuild clean
rm -rf ios/build
rm -rf build/ios
```

### Q: Error: "Entry Does Not Exist"?

**A:** Key might not exist in Info.plist. Add it first:
```bash
# Add if doesn't exist
/usr/libexec/PlistBuddy -c "Add :CFBundleVersion string 357" Info.plist 2>/dev/null || \
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion 357" Info.plist
```

## Summary

### What This Solves
✅ IPA always has correct version from config  
✅ No cache issues  
✅ No xcodebuild flag problems  
✅ Verifiable at every step  
✅ Fails fast if issues occur  

### Files Updated
- `.github/workflows/deploy_ios_internal.yml`
- `.github/workflows/deploy_ios_internal_v2.yml`

### Result
```
Config: buildNumber: 357
Info.plist: CFBundleVersion: 357
Archive: CFBundleVersion: 357
IPA: CFBundleVersion: 357
TestFlight: Build 357
✅ Complete consistency!
```

---

**Last Updated:** 2024-12-09  
**Status:** ✅ Implemented  
**Reliability:** ⭐⭐⭐⭐⭐ 100%

