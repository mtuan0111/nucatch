# 🌍 Multi-Language Release Notes Guide

## Overview

The version management system now supports **automatic generation of release notes in multiple languages**. All workflows will scan the `releaseNotes` object in the configuration and generate files for each language automatically.

## Configuration Format

In `.github/config/version-config.json`:

```json
{
  "android": {
    "dev": {
      "versionName": "3.12.1.4",
      "versionCode": 417,
      "releaseNotes": {
        "en-US": "Bug fixes and performance improvements",
        "vi-VN": "Sửa lỗi và cải thiện hiệu suất",
        "zh-CN": "错误修复和性能改进"
      }
    }
  }
}
```

## Supported Languages

You can add any language code. Common ones include:

| Language | Code | Example |
|----------|------|---------|
| English (US) | `en-US` | Bug fixes and improvements |
| Vietnamese | `vi-VN` | Sửa lỗi và cải thiện |
| Chinese (Simplified) | `zh-CN` | 错误修复和改进 |
| Chinese (Traditional) | `zh-TW` | 錯誤修復和改進 |
| Japanese | `ja-JP` | バグ修正とパフォーマンス改善 |
| Korean | `ko-KR` | 버그 수정 및 성능 개선 |
| Spanish | `es-ES` | Correcciones de errores y mejoras |
| French | `fr-FR` | Corrections de bugs et améliorations |
| German | `de-DE` | Fehlerbehebungen und Verbesserungen |
| Indonesian | `id-ID` | Perbaikan bug dan peningkatan kinerja |
| Thai | `th-TH` | แก้ไขข้อบกพร่องและปรับปรุงประสิทธิภาพ |

## Adding Release Notes

### Using the Script

```bash
cd .github/scripts

# Add English release notes (default)
./version-manager.sh android dev update-notes "Bug fixes and performance improvements"

# Add Vietnamese release notes
./version-manager.sh android dev update-notes "Sửa lỗi và cải thiện hiệu suất" vi-VN

# Add Chinese release notes
./version-manager.sh android dev update-notes "错误修复和性能改进" zh-CN
```

### Manual Edit

You can also edit `.github/config/version-config.json` directly:

```json
"releaseNotes": {
  "en-US": "What's New:\n• Fixed login issues\n• Improved performance\n• Updated UI",
  "vi-VN": "Có gì mới:\n• Sửa lỗi đăng nhập\n• Cải thiện hiệu suất\n• Cập nhật giao diện"
}
```

## How It Works

### 1. Configuration Storage
All release notes are stored in `version-config.json`:

```json
"releaseNotes": {
  "en-US": "English text",
  "vi-VN": "Vietnamese text"
}
```

### 2. Automatic File Generation
When you run the workflow or script, it automatically:

1. Scans all keys in the `releaseNotes` object
2. Generates a separate `.txt` file for each language
3. Places files in the correct directory

**Android:**
```
vinaresearch-flutter/distribution/whatsnew/
├── en-US.txt
├── vi-VN.txt
└── zh-CN.txt
```

**iOS:**
```
vinaresearch-flutter/distribution/whatsnew-ios/
├── en-US.txt
├── vi-VN.txt
└── zh-CN.txt
```

### 3. Store Upload
When uploading to Google Play or App Store, all language files are automatically included.

## Workflow Integration

### Android Workflow
```yaml
- name: 📝 Load release notes
  run: |
    # Get all language keys
    LANGUAGES=$(jq -r '.android.dev.releaseNotes | keys[]' .github/config/version-config.json)
    
    # Generate file for each language
    for LANG in $LANGUAGES; do
      NOTES=$(jq -r ".android.dev.releaseNotes[\"$LANG\"]" .github/config/version-config.json)
      echo "$NOTES" > "distribution/whatsnew/$LANG.txt"
    done
```

### iOS Workflow
```yaml
- name: 📝 Load release notes
  run: |
    # Get all language keys
    LANGUAGES=$(jq -r '.ios.dev.releaseNotes | keys[]' .github/config/version-config.json)
    
    # Generate file for each language
    for LANG in $LANGUAGES; do
      NOTES=$(jq -r ".ios.dev.releaseNotes[\"$LANG\"]" .github/config/version-config.json)
      echo "$NOTES" > "vinaresearch-flutter/distribution/whatsnew-ios/$LANG.txt"
    done
```

## Best Practices

### 1. Always Provide en-US
Keep `en-US` as the default language:

```json
"releaseNotes": {
  "en-US": "Bug fixes",  // Always include this
  "vi-VN": "Sửa lỗi"     // Additional languages
}
```

### 2. Keep Notes Consistent
Ensure all languages convey the same information:

```json
"releaseNotes": {
  "en-US": "• Fixed login bug\n• Improved performance",
  "vi-VN": "• Sửa lỗi đăng nhập\n• Cải thiện hiệu suất"
}
```

### 3. Respect Character Limits

**Google Play (Android):**
- Maximum: 500 characters per language
- Keep it concise

**App Store (iOS):**
- Maximum: 4000 characters per language
- Can be more detailed

### 4. Use Proper Encoding
Ensure your editor uses UTF-8 encoding to properly save Unicode characters.

### 5. Test Before Release
Always verify the generated files:

```bash
# After running the script
cat vinaresearch-flutter/distribution/whatsnew/vi-VN.txt
cat vinaresearch-flutter/distribution/whatsnew-ios/vi-VN.txt
```

## Examples

### Example 1: Simple Bug Fix

```json
"releaseNotes": {
  "en-US": "Bug fixes and performance improvements",
  "vi-VN": "Sửa lỗi và cải thiện hiệu suất"
}
```

### Example 2: Feature Release

```json
"releaseNotes": {
  "en-US": "What's New:\n• Dark mode support\n• Push notifications\n• Bug fixes",
  "vi-VN": "Có gì mới:\n• Hỗ trợ chế độ tối\n• Thông báo đẩy\n• Sửa lỗi",
  "zh-CN": "新增功能：\n• 深色模式支持\n• 推送通知\n• 错误修复"
}
```

### Example 3: Major Update

```json
"releaseNotes": {
  "en-US": "Major Update!\n\nNEW FEATURES\n• Redesigned UI\n• Offline mode\n• Voice search\n\nIMPROVEMENTS\n• 50% faster\n• Reduced memory usage\n\nBUG FIXES\n• Fixed crash issues\n• Improved stability",
  "vi-VN": "Cập nhật lớn!\n\nTÍNH NĂNG MỚI\n• Thiết kế lại giao diện\n• Chế độ ngoại tuyến\n• Tìm kiếm bằng giọng nói\n\nCẢI THIỆN\n• Nhanh hơn 50%\n• Giảm sử dụng bộ nhớ\n\nSỬA LỖI\n• Sửa lỗi crash\n• Cải thiện độ ổn định"
}
```

## Workflow Commands

### Add a New Language

```bash
# 1. Add English notes (if not exists)
./version-manager.sh android dev update-notes "Bug fixes" en-US

# 2. Add Vietnamese notes
./version-manager.sh android dev update-notes "Sửa lỗi" vi-VN

# 3. Add Chinese notes
./version-manager.sh android dev update-notes "错误修复" zh-CN

# 4. Commit changes
git add .github/config/version-config.json vinaresearch-flutter/distribution/
git commit -m "chore: add multi-language release notes"
git push
```

### Update Existing Language

```bash
# Update English
./version-manager.sh android dev update-notes "Updated features" en-US

# Update Vietnamese
./version-manager.sh android dev update-notes "Cập nhật tính năng" vi-VN
```

### Remove a Language

Edit the JSON file and remove the language key:

```json
"releaseNotes": {
  "en-US": "Bug fixes",
  // Remove this line:
  // "vi-VN": "Sửa lỗi"
}
```

Then regenerate files:
```bash
./version-manager.sh android dev update-notes "Bug fixes" en-US
```

## Platform-Specific Notes

### Google Play (Android)

- Supports multiple languages automatically
- Files are named by language code: `en-US.txt`, `vi-VN.txt`
- Maximum 500 characters per language
- Place in: `vinaresearch-flutter/distribution/whatsnew/`

### App Store (iOS)

- Supports multiple languages through TestFlight
- Files are named by language code: `en-US.txt`, `vi-VN.txt`
- Maximum 4000 characters per language
- Place in: `vinaresearch-flutter/distribution/whatsnew-ios/`

## Troubleshooting

### Issue: Release notes not showing for a language

**Solution:**
1. Check the language code is correct (e.g., `vi-VN` not `vi`)
2. Verify the file was generated: `ls -la vinaresearch-flutter/distribution/whatsnew/`
3. Ensure the file has content: `cat vinaresearch-flutter/distribution/whatsnew/vi-VN.txt`
4. Check Google Play Console / App Store Connect has that language enabled

### Issue: Special characters not displaying correctly

**Solution:**
1. Ensure your editor uses UTF-8 encoding
2. Verify the JSON file is valid: `jq empty .github/config/version-config.json`
3. Check the generated .txt files: `file vinaresearch-flutter/distribution/whatsnew/vi-VN.txt`

### Issue: Some languages not uploading

**Solution:**
1. Check file permissions: `ls -la vinaresearch-flutter/distribution/whatsnew/`
2. Verify all files are committed to Git
3. Check workflow logs for any errors during file generation

## Advanced Usage

### Script-Based Bulk Update

Create a script to update all languages at once:

```bash
#!/bin/bash

# update_all_languages.sh
cd .github/scripts

# English
./version-manager.sh android dev update-notes "Bug fixes and improvements" en-US

# Vietnamese
./version-manager.sh android dev update-notes "Sửa lỗi và cải thiện" vi-VN

# Chinese
./version-manager.sh android dev update-notes "错误修复和改进" zh-CN

echo "✅ All languages updated"
```

### JSON Template

Use this template for consistent formatting:

```json
{
  "releaseNotes": {
    "en-US": "English text here",
    "vi-VN": "Vietnamese text here",
    "zh-CN": "Chinese Simplified text here",
    "zh-TW": "Chinese Traditional text here",
    "ja-JP": "Japanese text here",
    "ko-KR": "Korean text here"
  }
}
```

## FAQ

**Q: How many languages can I add?**  
A: No limit! Add as many as needed.

**Q: Do I need to provide all languages for every release?**  
A: No, but it's recommended. Missing languages will fall back to the store's default.

**Q: Can I use the same text for multiple language codes?**  
A: Yes, but it's better to provide proper translations.

**Q: What happens if I only have en-US?**  
A: That's fine! The system works with any number of languages.

**Q: Can I use HTML or markdown in release notes?**  
A: No, use plain text with line breaks (`\n`) only.

## Summary

✅ **Multi-language support is automatic**  
✅ **Add any language code you need**  
✅ **Files are generated automatically**  
✅ **Works with both Android and iOS**  
✅ **Easy to add, update, or remove languages**  

---

**Next Steps:**
1. Add your languages to `version-config.json`
2. Use the script to update release notes
3. Commit and push
4. Watch the workflow generate all files automatically! 🎉

