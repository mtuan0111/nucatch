# 🔄 Migration Checklist: Version Management System

## Pre-Migration Checklist

### Prerequisites
- [ ] `jq` installed (`brew install jq`)
- [ ] Access to repository
- [ ] Understanding of current versions
- [ ] Backup of current workflow files

### Documentation Review
- [ ] Read [Quick Start Guide](docs/QUICK_START_VERSION_MANAGEMENT.md)
- [ ] Review [Full Documentation](docs/VERSION_MANAGEMENT.md)
- [ ] Understand version strategy

---

## Migration Steps

### Phase 1: Setup Configuration

#### Step 1.1: Set Current Versions
```bash
cd .github/scripts

# Android Development
./version-manager.sh android dev set 3.12.1.3 416

# Android Production
./version-manager.sh android prod set 3.12.1 416

# iOS Development
./version-manager.sh ios dev set 5.12.1 355.4

# iOS Production
./version-manager.sh ios prod set 5.12.1 355
```

**Checklist:**
- [ ] Android dev version set
- [ ] Android prod version set
- [ ] iOS dev version set
- [ ] iOS prod version set

#### Step 1.2: Set Release Notes
```bash
# Android
./version-manager.sh android dev update-notes "Bug fixes and performance improvements"
./version-manager.sh android prod update-notes "Bug fixes and performance improvements"

# iOS
./version-manager.sh ios dev update-notes "Bug fixes and performance improvements"
./version-manager.sh ios prod update-notes "Bug fixes and performance improvements"
```

**Checklist:**
- [ ] Android dev notes set
- [ ] Android prod notes set
- [ ] iOS dev notes set
- [ ] iOS prod notes set

#### Step 1.3: Verify Configuration
```bash
# Verify the config file
cat .github/config/version-config.json | jq '.'

# Verify release notes files exist
ls -la vinaresearch-flutter/distribution/whatsnew/
ls -la vinaresearch-flutter/distribution/whatsnew-ios/
```

**Checklist:**
- [ ] Config file valid JSON
- [ ] All versions present
- [ ] Release notes generated
- [ ] Files in correct locations

---

### Phase 2: Update Workflows

#### Step 2.1: Review New Workflows
**Checklist:**
- [ ] Review `.github/workflows/deploy_android_internal_v2.yml`
- [ ] Review `.github/workflows/deploy_ios_internal_v2.yml`
- [ ] Understand version loading steps
- [ ] Understand manual override feature

#### Step 2.2: Backup Old Workflows
```bash
# Create backup directory
mkdir -p .github/workflows/backup

# Backup old workflows
cp .github/workflows/deploy_android_internal.yml .github/workflows/backup/
cp .github/workflows/deploy_ios_internal.yml .github/workflows/backup/
```

**Checklist:**
- [ ] Old workflows backed up
- [ ] Backup directory created
- [ ] Files safely stored

#### Step 2.3: Activate New Workflows

**Option A: Gradual Migration (Recommended)**
```bash
# Keep old workflows active, enable new workflows alongside
# They can coexist - just use different branch triggers or manual dispatch
```

**Option B: Full Migration**
```bash
# Disable old workflows
mv .github/workflows/deploy_android_internal.yml .github/workflows/backup/
mv .github/workflows/deploy_ios_internal.yml .github/workflows/backup/

# Rename new workflows to primary names
mv .github/workflows/deploy_android_internal_v2.yml .github/workflows/deploy_android_internal.yml
mv .github/workflows/deploy_ios_internal_v2.yml .github/workflows/deploy_ios_internal.yml
```

**Checklist:**
- [ ] Migration approach chosen
- [ ] Workflows updated
- [ ] Branch triggers configured
- [ ] Manual dispatch tested

---

### Phase 3: Testing

#### Step 3.1: Test Version Manager Script
```bash
cd .github/scripts

# Test get
./version-manager.sh android dev get
./version-manager.sh ios dev get

# Test bump
./version-manager.sh android dev bump-patch
./version-manager.sh ios dev bump-patch

# Test export
./version-manager.sh android dev export
./version-manager.sh ios dev export
```

**Checklist:**
- [ ] `get` command works
- [ ] `bump-patch` works
- [ ] `bump-minor` works
- [ ] `bump-major` works
- [ ] `export` command works
- [ ] Release notes update works

#### Step 3.2: Test Workflows (Dev Environment)
```bash
# Commit changes
git add .github/
git commit -m "test: version management system"
git push origin development
```

**Checklist:**
- [ ] Workflow triggered successfully
- [ ] Version loaded from config
- [ ] Build used correct version
- [ ] Release notes included
- [ ] Build completed successfully

#### Step 3.3: Test Manual Deployment
1. Go to GitHub Actions
2. Select workflow
3. Click "Run workflow"
4. Enter version override
5. Run and verify

**Checklist:**
- [ ] Manual trigger works
- [ ] Version override works
- [ ] Build completes
- [ ] Correct version deployed

---

### Phase 4: Team Rollout

#### Step 4.1: Documentation
```bash
# Add to main README
echo "See .github/VERSION_MANAGEMENT_SUMMARY.md for version management" >> README.md
```

**Checklist:**
- [ ] Main README updated
- [ ] Team notified
- [ ] Documentation shared
- [ ] Training scheduled

#### Step 4.2: Team Training
**Topics to Cover:**
- [ ] How to check current version
- [ ] How to bump versions
- [ ] How to update release notes
- [ ] How to commit changes
- [ ] How to trigger deployments

#### Step 4.3: Process Update
**Checklist:**
- [ ] Update release process document
- [ ] Update contribution guidelines
- [ ] Update CI/CD documentation
- [ ] Update team wiki/notion

---

### Phase 5: Production Deployment

#### Step 5.1: Final Verification
```bash
# Verify all versions
./version-manager.sh android dev get
./version-manager.sh android prod get
./version-manager.sh ios dev get
./version-manager.sh ios prod get

# Verify release notes
cat vinaresearch-flutter/distribution/whatsnew/en-US.txt
cat vinaresearch-flutter/distribution/whatsnew-ios/en-US.txt
```

**Checklist:**
- [ ] All versions correct
- [ ] Release notes accurate
- [ ] No merge conflicts
- [ ] All tests passing

#### Step 5.2: Deploy to Production
```bash
# Create production release
./version-manager.sh android prod bump-patch
./version-manager.sh ios prod bump-patch

# Update release notes
./version-manager.sh android prod update-notes "Production release with bug fixes"
./version-manager.sh ios prod update-notes "Production release with bug fixes"

# Commit and push
git add .github/config/version-config.json vinaresearch-flutter/distribution/
git commit -m "chore: production release"
git push origin main
```

**Checklist:**
- [ ] Production version updated
- [ ] Release notes updated
- [ ] Changes committed
- [ ] Deployed successfully
- [ ] Version verified in stores

---

## Post-Migration

### Monitoring
**Week 1:**
- [ ] Monitor deployment success rate
- [ ] Check for version conflicts
- [ ] Verify release notes appear correctly
- [ ] Collect team feedback

**Week 2-4:**
- [ ] Review team adoption
- [ ] Address any issues
- [ ] Optimize process
- [ ] Document lessons learned

### Cleanup
Once confident the new system works:
- [ ] Remove old workflow files from backup
- [ ] Archive old documentation
- [ ] Update all references
- [ ] Celebrate success! 🎉

---

## Rollback Plan

If issues occur:

### Immediate Rollback
```bash
# Restore old workflows
cp .github/workflows/backup/deploy_android_internal.yml .github/workflows/
cp .github/workflows/backup/deploy_ios_internal.yml .github/workflows/

# Disable new workflows
mv .github/workflows/deploy_android_internal_v2.yml .github/workflows/disabled/
mv .github/workflows/deploy_ios_internal_v2.yml .github/workflows/disabled/

# Commit and push
git add .github/workflows/
git commit -m "rollback: revert to old version system"
git push
```

**Checklist:**
- [ ] Old workflows restored
- [ ] New workflows disabled
- [ ] Team notified
- [ ] Incident documented

---

## Success Metrics

Track these metrics to measure success:

### Quantitative
- [ ] Time to update version: Old ___ min → New ___ min
- [ ] Deployment success rate: Old ___% → New ___%
- [ ] Version conflicts: Old ___ → New ___
- [ ] Time to release: Old ___ → New ___

### Qualitative
- [ ] Team satisfaction increased
- [ ] Fewer manual errors
- [ ] Easier onboarding
- [ ] Better documentation

---

## Common Issues & Solutions

### Issue: "jq: command not found"
**Solution:**
```bash
brew install jq
```

### Issue: "Permission denied"
**Solution:**
```bash
chmod +x .github/scripts/version-manager.sh
```

### Issue: "Version not updating in build"
**Solution:**
- Ensure changes committed
- Check workflow using correct branch
- Verify workflow file has version loading step

### Issue: "Release notes not showing"
**Solution:**
- Check file location: `vinaresearch-flutter/distribution/whatsnew/en-US.txt`
- Verify file content length (max 500 chars for Android)
- Ensure file committed and pushed

---

## Support Contacts

| Issue Type | Contact |
|-----------|---------|
| Script issues | DevOps Team |
| Workflow issues | CI/CD Team |
| Documentation | Tech Writers |
| General questions | Team Lead |

---

## Appendix

### Useful Commands

```bash
# Quick status check
./version-manager.sh android dev get && ./version-manager.sh ios dev get

# Bump all dev versions
./version-manager.sh android dev bump-patch
./version-manager.sh ios dev bump-patch

# View config
cat .github/config/version-config.json | jq '.'

# View release notes
cat vinaresearch-flutter/distribution/whatsnew/en-US.txt
cat vinaresearch-flutter/distribution/whatsnew-ios/en-US.txt
```

### Links
- [Quick Start Guide](docs/QUICK_START_VERSION_MANAGEMENT.md)
- [Full Documentation](docs/VERSION_MANAGEMENT.md)
- [System Overview](README_VERSION_MANAGEMENT.md)
- [Summary](VERSION_MANAGEMENT_SUMMARY.md)

---

**Migration Status:** ⬜ Not Started

**Date Started:** ___________

**Date Completed:** ___________

**Migrated By:** ___________

---

**Print this checklist and check off items as you complete them!**

