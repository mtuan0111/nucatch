#!/usr/bin/env python3
"""
Disable Firebase Crashlytics Symbol Upload Scripts for CI Builds

This script modifies the Xcode project.pbxproj file to replace Crashlytics
symbol upload scripts with no-op echo commands. This prevents build failures
in CI environments where these scripts may not have proper authentication or
may cause warnings about missing output dependencies.

Usage:
    python3 disable_crashlytics_upload.py <path_to_project.pbxproj>

Example:
    python3 disable_crashlytics_upload.py ios/Runner.xcodeproj/project.pbxproj
"""

import sys
import re
import os
from pathlib import Path


def disable_crashlytics_upload(project_file_path):
    """
    Disable Crashlytics symbol upload scripts in Xcode project file.
    
    Args:
        project_file_path (str): Path to the project.pbxproj file
        
    Returns:
        bool: True if modifications were successful, False otherwise
    """
    project_path = Path(project_file_path)
    
    # Validate file exists
    if not project_path.exists():
        print(f"❌ ERROR: Project file not found at {project_file_path}")
        return False
    
    # Read the project file
    try:
        with open(project_path, 'r', encoding='utf-8') as f:
            original_content = f.read()
    except Exception as e:
        print(f"❌ ERROR: Failed to read project file: {e}")
        return False
    
    content = original_content
    modifications_made = False
    
    # Pattern 1: Firebase Crashlytics upload-symbols scripts
    # Matches: shellScript = "\"${PODS_ROOT}/FirebaseCrashlytics/upload-symbols\" ...";
    pattern1 = r'(shellScript = )"[^"]*firebase_crashlytics[^"]*upload-symbols[^"]*";'
    replacement1 = r'\1"echo \\"Skipping Firebase Crashlytics symbol upload in CI\\";";'
    
    if re.search(pattern1, content, re.IGNORECASE):
        content = re.sub(pattern1, replacement1, content, flags=re.IGNORECASE)
        modifications_made = True
        print("✅ Disabled Firebase Crashlytics upload-symbols script")
    
    # Pattern 2: FlutterFire upload-crashlytics-symbols scripts
    # Matches: shellScript = "\"flutterfire\" upload-crashlytics-symbols ...";
    pattern2 = r'(shellScript = )"[^"]*flutterfire[^"]*upload-crashlytics-symbols[^"]*";'
    replacement2 = r'\1"echo \\"Skipping FlutterFire Crashlytics symbol upload in CI\\";";'
    
    if re.search(pattern2, content, re.IGNORECASE):
        content = re.sub(pattern2, replacement2, content, flags=re.IGNORECASE)
        modifications_made = True
        print("✅ Disabled FlutterFire upload-crashlytics-symbols script")
    
    # Pattern 3: Generic Crashlytics script phases (backup pattern)
    # Matches any script containing "Crashlytics" and "upload" or "symbols"
    pattern3 = r'(shellScript = )"[^"]*[Cc]rashlytics[^"]*(?:upload|symbols)[^"]*";'
    if re.search(pattern3, content) and content == original_content:
        # Only apply if no previous patterns matched
        content = re.sub(
            pattern3,
            r'\1"echo \\"Skipping Crashlytics operations in CI\\";";',
            content
        )
        modifications_made = True
        print("✅ Disabled generic Crashlytics script")
    
    if not modifications_made:
        print("ℹ️  No Crashlytics upload scripts found to modify")
        return True  # Not an error, just nothing to do
    
    # Write the modified content back
    try:
        with open(project_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"✅ Successfully updated {project_file_path}")
        return True
    except Exception as e:
        print(f"❌ ERROR: Failed to write project file: {e}")
        return False


def main():
    """Main entry point for the script."""
    if len(sys.argv) != 2:
        print("Usage: python3 disable_crashlytics_upload.py <path_to_project.pbxproj>")
        print("\nExample:")
        print("  python3 disable_crashlytics_upload.py ios/Runner.xcodeproj/project.pbxproj")
        sys.exit(1)
    
    project_file = sys.argv[1]
    
    print("=" * 60)
    print("Disabling Firebase Crashlytics Symbol Upload for CI Build")
    print("=" * 60)
    print(f"Project file: {project_file}")
    print()
    
    success = disable_crashlytics_upload(project_file)
    
    if success:
        print()
        print("=" * 60)
        print("✅ Configuration completed successfully")
        print("=" * 60)
        sys.exit(0)
    else:
        print()
        print("=" * 60)
        print("❌ Configuration failed")
        print("=" * 60)
        sys.exit(1)


if __name__ == "__main__":
    main()
