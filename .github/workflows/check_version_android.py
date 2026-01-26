#!/usr/bin/env python3
"""
Android Version Checker for Google Play Console

This script checks if a given version code already exists in the specified track
of Google Play Console to prevent duplicate version uploads.

Usage:
    python3 check_version_android.py <package_name> <version_code> <version_name> <service_account_json_path> <track>

Returns:
    0 - Version is available (not found in specified track)
    1 - Version already exists in specified track
    0 - Error occurred but continuing (with warning)
"""

import sys
import json
from google.oauth2 import service_account
from googleapiclient.discovery import build


def check_version(package_name, version_code, version_name, service_account_path, track='internal'):
    """
    Check if the version code exists in Google Play Console specified track.
    
    Args:
        package_name: Android package name (e.g., com.example.app)
        version_code: Integer version code to check
        version_name: Version name string (for display only)
        service_account_path: Path to service account JSON file
        track: Track to check (e.g., 'internal', 'production', 'beta', 'alpha')
    
    Returns:
        bool: True if version exists, False if available
    """
    print(f"=== Google Play Console Version Checker ===")
    print(f"Package name: {package_name}")
    print(f"Track: {track}")
    print(f"Checking for version code: {version_code}")
    print(f"Version name: {version_name}")
    print("")
    
    try:
        # Authenticate with service account
        print("Authenticating with Google Play API...")
        credentials = service_account.Credentials.from_service_account_file(
            service_account_path,
            scopes=['https://www.googleapis.com/auth/androidpublisher']
        )
        
        # Build the service
        service = build('androidpublisher', 'v3', credentials=credentials)
        print("✅ Successfully authenticated with Google Play API")
        
        # Create an edit session
        print("\nCreating edit session...")
        edit_request = service.edits().insert(body={}, packageName=package_name)
        edit_result = edit_request.execute()
        edit_id = edit_result['id']
        print(f"✅ Edit session created: {edit_id}")
        
        # List all tracks
        print("")
        print("Fetching tracks from Google Play Console...")
        tracks_result = service.edits().tracks().list(
            packageName=package_name,
            editId=edit_id
        ).execute()
        
        # Find the specified track
        target_track = None
        for t in tracks_result.get('tracks', []):
            if t['track'] == track:
                target_track = t
                break
        
        if not target_track:
            print(f"✅ No {track} track found - this is the first release")
            print(f"\n{'='*60}")
            print(f"✅ VERSION VALIDATION SUCCESSFUL")
            print(f"{'='*60}")
            print(f"   Version code {version_code}: AVAILABLE ✓")
            print(f"   Version name '{version_name}': AVAILABLE ✓")
            print(f"")
            print(f"   No existing version codes found - this is the first release")
            print(f"")
            print(f"   ✅ Validation successful - proceeding with build")
            print(f"{'='*60}")
            return False
        
        # Check releases in specified track
        print(f"")
        print(f"Checking {track} track releases...")
        releases = target_track.get('releases', [])
        
        if not releases:
            print(f"✅ No releases found in {track} track - this is the first release")
            print(f"\n{'='*60}")
            print(f"✅ VERSION VALIDATION SUCCESSFUL")
            print(f"{'='*60}")
            print(f"   Version code {version_code}: AVAILABLE ✓")
            print(f"   Version name '{version_name}': AVAILABLE ✓")
            print(f"")
            print(f"   No existing version codes found - this is the first release")
            print(f"")
            print(f"   ✅ Validation successful - proceeding with build")
            print(f"{'='*60}")
            return False
        
        print(f"✅ Found {len(releases)} release(s) in {track} track")
        
        # Check if version code or version name exists
        version_code_exists = False
        version_name_exists = False
        existing_versions = []
        existing_version_names = []
        duplicate_release_info = {}
        
        for release in releases:
            release_name = release.get('name', 'Unnamed')
            release_status = release.get('status', 'unknown')
            version_codes = release.get('versionCodes', [])
            
            # Convert version codes to integers for proper comparison
            version_codes_int = []
            for vc in version_codes:
                try:
                    version_codes_int.append(int(vc))
                except (ValueError, TypeError):
                    print(f"⚠️ Warning: Invalid version code '{vc}' in release '{release_name}'")
            
            existing_versions.extend(version_codes_int)
            
            # Get version name from release name (Play Store uses release name as version name)
            # or check in versionCodes mapping if available
            if release_name and release_name != 'Unnamed':
                existing_version_names.append(release_name)
            
            print(f"  Release: {release_name}")
            print(f"    Status: {release_status}")
            print(f"    Version codes: {version_codes_int}")
            
            # Check if version code exists (compare with integer version codes)
            if version_code in version_codes_int:
                version_code_exists = True
                duplicate_release_info['version_code'] = {
                    'release_name': release_name,
                    'status': release_status
                }
                print(f"\n❌ ERROR: Version code {version_code} already exists in {track} track!")
                print(f"   Release name: {release_name}")
                print(f"   Status: {release_status}")
            
            # Check if version name matches
            if release_name == version_name:
                version_name_exists = True
                duplicate_release_info['version_name'] = {
                    'release_name': release_name,
                    'status': release_status,
                    'version_codes': version_codes_int
                }
                print(f"\n❌ ERROR: Version name '{version_name}' already exists in {track} track!")
                print(f"   Status: {release_status}")
                print(f"   Version codes: {version_codes_int}")
        
        # Get the latest version code
        latest_version = max(existing_versions) if existing_versions else 0
        
        # Check if either version code or version name already exists
        has_error = False
        
        if version_code_exists:
            print(f"\n{'='*60}")
            print(f"❌ ERROR #1: VERSION CODE ALREADY EXISTS")
            print(f"{'='*60}")
            print(f"   Version code {version_code} is ALREADY IN USE in Google Play Console")
            print(f"   Google Play Store does NOT allow duplicate version codes!")
            print(f"")
            print(f"   Current version code: {version_code}")
            print(f"   Latest version code in Play Store: {latest_version}")
            if duplicate_release_info.get('version_code'):
                info = duplicate_release_info['version_code']
                print(f"   Found in release: {info['release_name']}")
                print(f"   Release status: {info['status']}")
            print(f"")
            print(f"   ⚠️  Action Required:")
            print(f"   Please increment the version code in .github/config/version-config.json")
            print(f"   Suggested next version code: {latest_version + 1}")
            has_error = True
        
        if version_name_exists:
            print(f"\n{'='*60}")
            print(f"❌ ERROR #2: VERSION NAME ALREADY EXISTS")
            print(f"{'='*60}")
            print(f"   Version name '{version_name}' is ALREADY IN USE in Google Play Console")
            print(f"   Using duplicate version names can cause confusion!")
            print(f"")
            if duplicate_release_info.get('version_name'):
                info = duplicate_release_info['version_name']
                print(f"   Release status: {info['status']}")
                print(f"   Associated version codes: {info['version_codes']}")
            print(f"")
            print(f"   ⚠️  Action Required:")
            print(f"   Please update the version name in .github/config/version-config.json")
            print(f"   Current version name: {version_name}")
            print(f"   Suggested: Increment the version name (e.g., bump patch, minor, or major)")
            has_error = True
        
        if has_error:
            print(f"\n{'='*60}")
            print(f"=== Recent releases in {track.capitalize()} track ===")
            print(f"{'='*60}")
            
            # Show version codes
            print(f"\nVersion Codes:")
            existing_versions_sorted = sorted(set(existing_versions), reverse=True)
            for i, vc in enumerate(existing_versions_sorted[:10], 1):
                marker = " ← YOUR VERSION (DUPLICATE!)" if vc == version_code else ""
                print(f"  {i}. Version code: {vc}{marker}")
            
            if len(existing_versions_sorted) > 10:
                print(f"  ... and {len(existing_versions_sorted) - 10} more")
            
            # Show version names
            if existing_version_names:
                print(f"\nVersion Names:")
                unique_version_names = list(dict.fromkeys(existing_version_names))  # Preserve order, remove duplicates
                for i, vn in enumerate(unique_version_names[:10], 1):
                    marker = " ← YOUR VERSION (DUPLICATE!)" if vn == version_name else ""
                    print(f"  {i}. Version name: {vn}{marker}")
                
                if len(unique_version_names) > 10:
                    print(f"  ... and {len(unique_version_names) - 10} more")
            
            print(f"\n{'='*60}")
            print(f"❌ BUILD FAILED: Cannot upload duplicate version to Google Play Store")
            print(f"{'='*60}")
            return True
        
        # Check if version code is greater than all existing versions (only if no other errors)
        if not has_error and latest_version > 0 and version_code <= latest_version:
            print(f"\n{'='*60}")
            print(f"❌ ERROR #3: VERSION CODE TOO LOW")
            print(f"{'='*60}")
            print(f"   Version code {version_code} is NOT GREATER than existing versions")
            print(f"   Google Play Store requires version codes to be STRICTLY INCREASING!")
            print(f"")
            print(f"   Latest version code in Play Store: {latest_version}")
            print(f"   Your version code: {version_code}")
            print(f"   Difference: {version_code - latest_version} (Must be positive!)")
            print(f"")
            print(f"   ⚠️  Action Required:")
            print(f"   Please use a version code GREATER than {latest_version}")
            print(f"   Suggested next version code: {latest_version + 1}")
            print(f"\n{'='*60}")
            print(f"=== Recent version codes in {track.capitalize()} track ===")
            print(f"{'='*60}")
            existing_versions_sorted = sorted(set(existing_versions), reverse=True)
            for i, vc in enumerate(existing_versions_sorted[:10], 1):
                marker = " ← Your version (TOO LOW!)" if vc == version_code else ""
                status = " [Current]" if i == 1 else ""
                print(f"  {i}. Version code: {vc}{status}{marker}")
            
            if len(existing_versions_sorted) > 10:
                print(f"  ... and {len(existing_versions_sorted) - 10} more")
            
            print(f"\n{'='*60}")
            print(f"❌ BUILD FAILED: Version code must be greater than {latest_version}")
            print(f"{'='*60}")
            return True
        
        # Both version code and version name are valid
        print(f"\n{'='*60}")
        print(f"✅ VERSION VALIDATION SUCCESSFUL")
        print(f"{'='*60}")
        print(f"   Version code {version_code}: AVAILABLE ✓")
        print(f"   Version name '{version_name}': AVAILABLE ✓")
        print(f"")
        if existing_versions:
            print(f"   Latest version code in Play Store: {latest_version}")
            print(f"   Your version code: {version_code}")
            print(f"   Difference: +{version_code - latest_version} (Valid ✓)")
        else:
            print(f"   No existing version codes found - this is the first release")
        print(f"")
        print(f"   ✅ Validation successful - proceeding with build")
        print(f"{'='*60}")
        return False
    
    except Exception as e:
        print(f"\n❌ Error: Failed to validate version")
        print(f"Error: {str(e)}")
        print(f"Error type: {type(e).__name__}")
        print("\nProceeding with build (unable to verify version)...")
        return True # Continue build on error


def main():
    """Main entry point"""
    if len(sys.argv) not in [5, 6]:
        print("Usage: python3 check_version_android.py <package_name> <version_code> <version_name> <service_account_json_path> [track]")
        print("  track: Optional, defaults to 'internal'. Can be 'internal', 'production', 'beta', or 'alpha'")
        sys.exit(1)
    
    package_name = sys.argv[1]
    try:
        version_code = int(sys.argv[2])
    except ValueError:
        print(f"❌ ERROR: Version code must be an integer, got: {sys.argv[2]}")
        sys.exit(1)
    
    version_name = sys.argv[3]
    service_account_path = sys.argv[4]
    track = sys.argv[5] if len(sys.argv) == 6 else 'internal'  # Default to 'internal' for backwards compatibility
    
    # Check if version exists
    version_exists = check_version(package_name, version_code, version_name, service_account_path, track)
    
    # Exit with appropriate code
    if version_exists:
        sys.exit(1)  # Version exists - fail the build
    else:
        sys.exit(0)  # Version available or error (continue)


if __name__ == '__main__':
    main()
