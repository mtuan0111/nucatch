# 📱 App Version Management System

A centralized, automated system for managing app versions and release notes for both iOS and Android platforms.

## 🌟 Features

- ✅ **Centralized Configuration** - Single source of truth for all version information
- ✅ **Separate iOS & Android Versions** - Independent version management for each platform
- ✅ **Environment Support** - Different versions for `dev` and `prod` environments
- ✅ **Automated Release Notes** - Generate what's new files automatically
- ✅ **Version Bumping** - Easy semantic versioning (major.minor.patch)
- ✅ **CI/CD Integration** - GitHub Actions workflows read from config
- ✅ **Manual Override** - Option to override versions during deployment
- ✅ **Multi-language Support** - Ready for localized release notes

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [System Architecture](#system-architecture)
- [Configuration File](#configuration-file)
- [Version Manager Script](#version-manager-script)
- [Workflow Integration](#workflow-integration)
- [Release Notes Management](#release-notes-management)
- [Best Practices](#best-practices)
- [Migration Guide](#migration-guide)

## 🚀 Quick Start

### 1. Check Current Versions

```bash
cd .github/scripts
./version-manager.sh android dev get
./version-manager.sh ios dev get
```

### 2. Bump Version

```bash
# For bug fixes
./version-manager.sh android dev bump-patch

# For new features
./version-manager.sh ios dev bump-minor
```

### 3. Update Release Notes

```bash
./version-manager.sh android dev update-notes "Fixed login bug and improved performance"
```

### 4. Commit and Deploy

```bash
git add .github/config/version-config.json vinaresearch-flutter/distribution/
git commit -m "chore: release v3.12.2"
git push origin development
```

📚 **Full Guide:** [Quick Start Guide](docs/QUICK_START_VERSION_MANAGEMENT.md)

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────┐
│          version-config.json (Source of Truth)       │
│  ┌──────────────┐              ┌──────────────┐    │
│  │   Android    │              │     iOS      │    │
│  │  dev / prod  │              │  dev / prod  │    │
│  └──────────────┘              └──────────────┘    │
└─────────────────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
        ▼                       ▼
┌──────────────┐      ┌──────────────────┐
│version-      │      │   GitHub Actions │
│manager.sh    │      │   Workflows      │
└──────────────┘      └──────────────────┘
        │                       │
        └───────────┬───────────┘
                    │
                    ▼
        ┌─────────────────────┐
        │  Release Notes      │
        │  whatsnew/*.txt     │
        └─────────────────────┘
                    │
                    ▼
        ┌─────────────────────┐
        │  App Store /        │
        │  Google Play        │
        └─────────────────────┘
```

### Components

| Component | Purpose | Location |
|-----------|---------|----------|
| **version-config.json** | Central configuration | `.github/config/` |
| **version-manager.sh** | Management script | `.github/scripts/` |
| **Workflows v2** | CI/CD pipelines | `.github/workflows/*_v2.yml` |
| **Release Notes** | What's new files | `vinaresearch-flutter/distribution/` |
| **Documentation** | Guides and docs | `.github/docs/` |

## 📝 Configuration File

Location: `.github/config/version-config.json`

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
  }
}
```

### Version Fields

**Android:**
- `versionName`: User-visible version (e.g., "3.12.1")
- `versionCode`: Integer that must increase with each release

**iOS:**
- `versionName`: User-visible version (e.g., "5.12.1")
- `buildNumber`: Build identifier (can be integer or decimal)

## 🛠️ Version Manager Script

Location: `.github/scripts/version-manager.sh`

### Usage

```bash
./version-manager.sh [platform] [environment] [action] [args...]
```

### Examples

```bash
# Get version
./version-manager.sh android dev get

# Bump versions
./version-manager.sh android dev bump-patch   # 3.12.1 → 3.12.2
./version-manager.sh ios dev bump-minor       # 5.12.1 → 5.13.0
./version-manager.sh android prod bump-major  # 3.12.1 → 4.0.0

# Set custom version
./version-manager.sh android dev set 3.15.0 450
./version-manager.sh ios prod set 6.0.0 400

# Update release notes
./version-manager.sh android dev update-notes "Fixed critical bug"

# Export for CI/CD
./version-manager.sh android dev export
```

## 🔄 Workflow Integration

### New Workflows (Recommended)

**Android:** `.github/workflows/deploy_android_internal_v2.yml`  
**iOS:** `.github/workflows/deploy_ios_internal_v2.yml`

These workflows:
- ✅ Automatically read version from config file
- ✅ Generate release notes files
- ✅ Support manual version override
- ✅ Provide detailed build summaries

### How It Works

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
      --build-number=${{ steps.version.outputs.VERSION_CODE }}
```

### Manual Deployment with Override

1. Go to GitHub Actions
2. Select workflow
3. Click "Run workflow"
4. Enter version override: `3.12.2,417`
5. Click "Run workflow"

## 📄 Release Notes Management

### Automatic Generation

Release notes are automatically generated when you run:

```bash
./version-manager.sh android dev update-notes "Your release notes here"
```

This creates:
- `vinaresearch-flutter/distribution/whatsnew/en-US.txt` (Android)
- `vinaresearch-flutter/distribution/whatsnew-ios/en-US.txt` (iOS)

### Format Guidelines

**Android (Google Play) - Max 500 characters:**
```
New in this version:
• Fixed login issues
• Improved performance
• Updated UI design
```

**iOS (TestFlight/App Store) - Max 4000 characters:**
```
What's New:

NEW FEATURES
• Dark mode support
• Push notifications

IMPROVEMENTS
• 50% faster startup
• Reduced memory usage

BUG FIXES
• Fixed crash on iOS 15
```

### Multi-Language Support

To add Vietnamese release notes:

```json
"releaseNotes": {
  "en-US": "Bug fixes and improvements",
  "vi-VN": "Sửa lỗi và cải thiện hiệu suất"
}
```

## ✅ Best Practices

### Semantic Versioning

Follow [Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH`

- **MAJOR** (X.0.0): Breaking changes
- **MINOR** (x.X.0): New features (backward compatible)
- **PATCH** (x.x.X): Bug fixes

### Version Strategy

| Scenario | Action | Example |
|----------|--------|---------|
| Bug fix | `bump-patch` | 3.12.1 → 3.12.2 |
| New feature | `bump-minor` | 3.12.1 → 3.13.0 |
| Breaking change | `bump-major` | 3.12.1 → 4.0.0 |

### Development vs Production

- **Dev versions** can have more frequent bumps and build metadata
- **Prod versions** should follow strict semantic versioning
- Always test in `dev` before releasing to `prod`

### Commit Messages

```bash
# Good
git commit -m "fix: authentication bug - v3.12.2"
git commit -m "feat: dark mode support - v3.13.0"
git commit -m "chore: bump version to v3.12.2"

# Bad
git commit -m "update version"
git commit -m "changes"
```

## 🔄 Migration Guide

### From Hardcoded Versions to Config-Based

**Step 1:** Update the config file

```bash
# Set current versions
./version-manager.sh android dev set 3.12.1.3 416
./version-manager.sh ios dev set 5.12.1 355.4
```

**Step 2:** Switch to v2 workflows

Rename or update your workflow files to use the new format:
- `deploy_android_internal_v2.yml`
- `deploy_ios_internal_v2.yml`

**Step 3:** Test the new workflow

```bash
# Commit and push
git add .github/
git commit -m "chore: migrate to version management system"
git push origin development
```

**Step 4:** Verify

Check GitHub Actions to ensure the workflow picks up the correct version.

## 📊 Comparison: Old vs New

| Feature | Old System | New System |
|---------|-----------|------------|
| Version location | Hardcoded in workflow | Centralized config file |
| Update process | Edit YAML file | Run script command |
| Release notes | Manual file creation | Auto-generated |
| Version visibility | Hidden in workflow | Easy to view/track |
| Manual override | Not supported | Supported via workflow_dispatch |
| Multi-environment | Not supported | Separate dev/prod configs |
| Version validation | None | Built-in validation |
| History tracking | Git commits only | Config + timestamps |

## 📞 Support

### Documentation

- 📖 [Full Documentation](docs/VERSION_MANAGEMENT.md)
- 🚀 [Quick Start Guide](docs/QUICK_START_VERSION_MANAGEMENT.md)

### Troubleshooting

**Common Issues:**

1. **"jq: command not found"**
   ```bash
   brew install jq
   ```

2. **"Version not updating"**
   - Ensure changes are committed and pushed
   - Check workflow is using `*_v2.yml`

3. **"Build number too low"**
   ```bash
   ./version-manager.sh ios prod set 5.12.1 450
   ```

### Getting Help

- 💬 Ask the DevOps team
- 🐛 Report script issues
- 📝 Check documentation

## 🎯 Future Enhancements

- [ ] Automatic version bumping on merge
- [ ] Slack notifications for new releases
- [ ] Version history dashboard
- [ ] Multi-language release notes support
- [ ] Integration with CHANGELOG.md
- [ ] Version analytics and tracking

## 📜 License

This version management system is part of the internal development tools and follows the same license as the main project.

---

**Last Updated:** 2024-12-09  
**Maintained By:** DevOps Team

