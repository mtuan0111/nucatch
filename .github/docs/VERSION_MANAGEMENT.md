# Version Management Guide

This guide explains how to manage app versions for both iOS and Android builds using our centralized version management system.

## Overview

All version information is stored in `.github/config/version-config.json` and managed through the `.github/scripts/version-manager.sh` script.

## File Structure

```
.github/
├── config/
│   └── version-config.json          # Central version configuration
├── scripts/
│   └── version-manager.sh           # Version management script
└── docs/
    └── VERSION_MANAGEMENT.md        # This file

vinaresearch-flutter/
└── distribution/
    ├── whatsnew/                    # Android release notes
    │   └── en-US.txt
    └── whatsnew-ios/                # iOS release notes
        └── en-US.txt
```

## Version Configuration Format

The `version-config.json` file contains:

```json
{
  "android": {
    "dev": {
      "versionName": "3.12.1.3",
      "versionCode": 416,
      "releaseNotes": {
        "en-US": "Bug fixes and performance improvements"
      }
    },
    "prod": {
      "versionName": "3.12.1",
      "versionCode": 416,
      "releaseNotes": {
        "en-US": "Bug fixes and performance improvements"
      }
    }
  },
  "ios": {
    "dev": {
      "versionName": "5.12.1",
      "buildNumber": "355.4",
      "releaseNotes": {
        "en-US": "Bug fixes and performance improvements"
      }
    },
    "prod": {
      "versionName": "5.12.1",
      "buildNumber": "355",
      "releaseNotes": {
        "en-US": "Bug fixes and performance improvements"
      }
    }
  },
  "metadata": {
    "lastUpdated": "2024-12-09T00:00:00Z",
    "updatedBy": "CI/CD Pipeline"
  }
}
```

## Using the Version Manager Script

### Prerequisites

Install `jq` (JSON processor):
```bash
brew install jq
```

### Basic Usage

```bash
cd .github/scripts
./version-manager.sh [platform] [environment] [action] [args...]
```

**Parameters:**
- `platform`: `android` or `ios`
- `environment`: `dev` or `prod`
- `action`: See actions below

### Available Actions

#### 1. Get Current Version

```bash
# Get Android dev version
./version-manager.sh android dev get

# Get iOS production version
./version-manager.sh ios prod get
```

Output:
```
ℹ️  Current version for android (dev):
versionName: 3.12.1.3
versionCode: 416
```

#### 2. Bump Version (Auto-increment)

Automatically increment version numbers:

```bash
# Bump patch version (x.x.X)
./version-manager.sh android dev bump-patch
# Result: 3.12.1 → 3.12.2 (and versionCode 416 → 417)

# Bump minor version (x.X.0)
./version-manager.sh ios dev bump-minor
# Result: 5.12.1 → 5.13.0

# Bump major version (X.0.0)
./version-manager.sh android prod bump-major
# Result: 3.12.1 → 4.0.0
```

#### 3. Set Custom Version

Set a specific version manually:

```bash
# Set Android version
./version-manager.sh android dev set 3.13.0 420

# Set iOS version
./version-manager.sh ios prod set 5.13.0 356
```

#### 4. Update Release Notes

Update what's new / release notes:

```bash
# Update Android dev release notes
./version-manager.sh android dev update-notes "Fixed critical bug in user authentication"

# Update iOS production release notes
./version-manager.sh ios prod update-notes "New features:
- Dark mode support
- Improved performance
- Bug fixes"
```

This automatically:
- Updates the JSON configuration
- Generates `whatsnew/en-US.txt` (Android) or `whatsnew-ios/en-US.txt` (iOS)

#### 5. Export for GitHub Actions

Export version as environment variables for CI/CD:

```bash
./version-manager.sh android dev export
# Output:
# ANDROID_VERSION_NAME=3.12.1.3
# ANDROID_VERSION_CODE=416
```

## Workflow Integration

The GitHub Actions workflows automatically read version information from the configuration file.

### In GitHub Actions Workflow

```yaml
- name: Load version configuration
  id: version
  run: |
    VERSION_NAME=$(jq -r '.android.dev.versionName' .github/config/version-config.json)
    VERSION_CODE=$(jq -r '.android.dev.versionCode' .github/config/version-config.json)
    echo "VERSION_NAME=$VERSION_NAME" >> $GITHUB_OUTPUT
    echo "VERSION_CODE=$VERSION_CODE" >> $GITHUB_OUTPUT

- name: Build Android App Bundle
  run: |
    flutter build appbundle \
      --build-name=${{ steps.version.outputs.VERSION_NAME }} \
      --build-number=${{ steps.version.outputs.VERSION_CODE }} \
      --release
```

## Version Strategy

### Semantic Versioning

We follow semantic versioning: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes or major new features
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Environment-Specific Versions

#### Development (`dev`)
- Used for internal testing and TestFlight/Internal Test Track
- Can have more frequent version bumps
- May include build metadata (e.g., `3.12.1.3`)

#### Production (`prod`)
- Used for public releases to App Store/Play Store
- Follows strict semantic versioning
- Clean version numbers (e.g., `3.12.1`)

### Version Code / Build Number

**Android (`versionCode`):**
- Integer that increments with each build
- Must always increase for Play Store
- Auto-incremented by `bump-*` commands

**iOS (`buildNumber`):**
- String that increments with each build
- Must increase for App Store
- Can be integer or decimal (e.g., `355` or `355.4`)

## Common Workflows

### Scenario 1: Bug Fix Release

```bash
# Update version
./version-manager.sh android prod bump-patch

# Update release notes
./version-manager.sh android prod update-notes "Fixed critical authentication bug"

# Commit changes
git add .github/config/version-config.json vinaresearch-flutter/distribution/
git commit -m "chore: bump version to $(jq -r '.android.prod.versionName' .github/config/version-config.json)"
git push origin development
```

### Scenario 2: New Feature Release

```bash
# Bump minor version
./version-manager.sh ios prod bump-minor

# Update release notes
./version-manager.sh ios prod update-notes "New features:
- Dark mode support
- Push notifications
- Performance improvements"

# Commit and push
git add .github/config/version-config.json vinaresearch-flutter/distribution/
git commit -m "chore: release v$(jq -r '.ios.prod.versionName' .github/config/version-config.json)"
git push origin development
```

### Scenario 3: Internal Testing Build

```bash
# Bump dev version
./version-manager.sh android dev bump-patch

# Update notes
./version-manager.sh android dev update-notes "Internal test build - testing new payment flow"

# Push to trigger CI/CD
git add . && git commit -m "chore: dev build" && git push
```

## Release Notes Best Practices

### Format for Google Play (Android)

Maximum 500 characters. Be concise:

```
New in this version:
• Fixed login issues
• Improved app performance
• Updated UI design
• Bug fixes
```

### Format for App Store (iOS)

Maximum 4000 characters. Can be more detailed:

```
What's New:

NEW FEATURES
• Dark Mode: Toggle between light and dark themes
• Push Notifications: Get instant updates
• Offline Mode: Access your content without internet

IMPROVEMENTS
• 50% faster app startup time
• Reduced memory usage
• Enhanced security

BUG FIXES
• Fixed crash on iOS 15
• Resolved login issues
• Fixed display issues on iPad
```

## Multi-Language Support

To add support for multiple languages:

1. Update `version-config.json`:
```json
"releaseNotes": {
  "en-US": "Bug fixes and improvements",
  "vi-VN": "Sửa lỗi và cải thiện hiệu suất"
}
```

2. Update `version-manager.sh` to generate multiple files:
```bash
# In generate_whatsnew_files function
for lang in $(jq -r ".$PLATFORM.$ENVIRONMENT.releaseNotes | keys[]" "$CONFIG_FILE"); do
    NOTES=$(jq -r ".$PLATFORM.$ENVIRONMENT.releaseNotes[\"$lang\"]" "$CONFIG_FILE")
    echo "$NOTES" > "$WHATSNEW_DIR/$lang.txt"
done
```

## Troubleshooting

### Issue: Version not updating in build

**Solution:** Ensure you've committed the changes and the workflow is reading from the correct branch.

### Issue: Build number conflict on App Store

**Solution:** Build numbers must always increase. Check the current build number on App Store Connect and set a higher number:
```bash
./version-manager.sh ios prod set 5.12.1 400
```

### Issue: Release notes not showing in Play Store

**Solution:** 
- Ensure file is in correct location: `vinaresearch-flutter/distribution/whatsnew/en-US.txt`
- Check file has no BOM (Byte Order Mark)
- Verify maximum 500 characters

## Automation Tips

### Pre-commit Hook

Create `.git/hooks/pre-commit`:
```bash
#!/bin/bash
# Validate version config before commit
if ! jq empty .github/config/version-config.json 2>/dev/null; then
    echo "Error: Invalid JSON in version-config.json"
    exit 1
fi
```

### Automated Version Bumping

Add to your CI/CD pipeline:
```yaml
- name: Auto-bump version for dev builds
  if: github.ref == 'refs/heads/development'
  run: |
    cd .github/scripts
    ./version-manager.sh android dev bump-patch
    ./version-manager.sh ios dev bump-patch
    git config user.name "GitHub Actions"
    git config user.email "actions@github.com"
    git add ../config/version-config.json
    git commit -m "chore: auto-bump dev version [skip ci]"
    git push
```

## Version History

Track version history in `CHANGELOG.md`:

```markdown
# Changelog

## [5.12.1] - 2024-12-09
### Fixed
- Critical authentication bug
- Memory leak in image loading

## [5.12.0] - 2024-12-01
### Added
- Dark mode support
- Push notifications
```

## Support

For issues or questions:
1. Check this documentation
2. Review `version-config.json` format
3. Test with `./version-manager.sh android dev get`
4. Contact the DevOps team

