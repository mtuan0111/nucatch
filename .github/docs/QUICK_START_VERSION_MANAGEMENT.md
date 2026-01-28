# Quick Start: Version Management

## 🚀 Getting Started in 5 Minutes

### Step 1: Install Prerequisites

```bash
# Install jq (JSON processor)
brew install jq
```

### Step 2: Check Current Versions

```bash
cd .github/scripts

# Check Android dev version
./version-manager.sh android dev get

# Check iOS dev version
./version-manager.sh ios dev get
```

Output:
```
ℹ️  Current version for android (dev):
versionName: 2.0.0
versionCode: 31
```

### Step 3: Update Version Before Release

```bash
# For a bug fix (patch version)
./version-manager.sh android dev bump-patch

# For new features (minor version)
./version-manager.sh ios dev bump-minor

# For breaking changes (major version)
./version-manager.sh android prod bump-major
```

### Step 4: Update Release Notes

```bash
# Update what users will see
./version-manager.sh android dev update-notes "Fixed login issues and improved performance"
```

### Step 5: Commit and Push

```bash
# Commit the version changes
git add .github/config/version-config.json
git commit -m "chore: bump version and update release notes"
git push origin development
```

That's it! 🎉 The CI/CD pipeline will automatically use the new version.

---

## 📱 Common Tasks

### Release a Bug Fix

```bash
# 1. Bump patch version
./version-manager.sh android dev bump-patch

# 2. Update notes
./version-manager.sh android dev update-notes "Fixed critical authentication bug"

# 3. Commit and push
git add .github/config/version-config.json
git commit -m "fix: authentication bug - v$(jq -r '.android.dev.versionName' ../config/version-config.json)"
git push
```

### Release New Features

```bash
# 1. Bump minor version
./version-manager.sh ios prod bump-minor

# 2. Update notes with bullet points
./version-manager.sh ios prod update-notes "New features:
- Dark mode support
- Push notifications
- Offline mode"

# 3. Commit and push
git add .github/config/version-config.json
git commit -m "feat: new features - v$(jq -r '.ios.prod.versionName' ../config/version-config.json)"
git push
```

### Set Custom Version (Advanced)

```bash
# If you need a specific version number
./version-manager.sh android dev set 3.0.0 50
./version-manager.sh ios prod set 3.0.0 50
```

---

## 🔄 Workflow Integration

The workflows automatically read versions from the config file.

### Automatic Triggers

| Branch | Workflow | Track |
|--------|----------|-------|
| `development` | Android/iOS Internal | Internal Testing |
| `main` | Android/iOS Release | Production |

### Manual Deployment with Custom Version

You can override the version when manually triggering a workflow:

1. Go to GitHub Actions
2. Select the workflow (e.g., "Android Internal Test Deployment")
3. Click "Run workflow"
4. Enter version override: `2.1.0,35` (format: versionName,versionCode)
5. Click "Run workflow"

---

## 📁 File Locations

| File | Purpose |
|------|---------|
| `.github/config/version-config.json` | Central version configuration |
| `.github/scripts/version-manager.sh` | Version management script |
| `distribution/whatsnew/en-US.txt` | Android release notes |
| `distribution/whatsnew-ios/en-US.txt` | iOS release notes |

---

## ❓ Troubleshooting

### "jq: command not found"
```bash
brew install jq
```

### "Version not updating in build"
Make sure you:
1. Committed the changes: `git add .github/config/version-config.json`
2. Pushed to the correct branch: `git push origin development`
3. Workflow is reading the correct branch

### "Build number must be higher"
Check the current build number in App Store Connect / Play Console and set a higher number:
```bash
./version-manager.sh ios prod set 2.0.0 45
```

---

## 🎯 Best Practices

1. **Always bump patch** for bug fixes
2. **Always bump minor** for new features
3. **Always bump major** for breaking changes
4. **Update release notes** before each release
5. **Commit version and notes together**
6. **Use descriptive commit messages**

---

## 🔗 Quick Links

| Task | Command |
|------|---------|
| View current version | `./version-manager.sh android dev get` |
| Bump patch version | `./version-manager.sh android dev bump-patch` |
| Update release notes | `./version-manager.sh android dev update-notes "Your notes"` |
| View help | `./version-manager.sh` |

---

**Remember:** Version numbers must always increase for app store submissions!
