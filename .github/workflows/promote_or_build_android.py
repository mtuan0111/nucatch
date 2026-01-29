#!/usr/bin/env python3
"""
Android Promote or Build Checker for Google Play Console

This script checks if a given version code already exists in the internal track
of Google Play Console. If it exists, it returns PROMOTE to indicate the build
should be promoted from internal to production. Otherwise, it returns BUILD.

Usage:
    python3 promote_or_build_android.py <package_name> <version_code> <version_name> <service_account_json_path>

Returns:
    0 - Success (outputs PROMOTE or BUILD to stdout)
    1 - Error occurred
"""

import sys
import json
from google.oauth2 import service_account
from googleapiclient.discovery import build


def check_internal_track(package_name, version_code, version_name, service_account_path):
    """
    Check if the version code exists in Google Play Console internal track.
    
    Args:
        package_name: Android package name (e.g., com.example.app)
        version_code: Integer version code to check
        version_name: Version name string (for display only)
        service_account_path: Path to service account JSON file
    
    Returns:
        tuple: (action, message) where action is 'PROMOTE' or 'BUILD'
    """
    print(f"=== Google Play Console Internal Track Checker ===", file=sys.stderr)
    print(f"Package name: {package_name}", file=sys.stderr)
    print(f"Checking for version code: {version_code}", file=sys.stderr)
    print(f"Version name: {version_name}", file=sys.stderr)
    print("", file=sys.stderr)
    
    try:
        # Authenticate with service account
        print("Authenticating with Google Play API...", file=sys.stderr)
        credentials = service_account.Credentials.from_service_account_file(
            service_account_path,
            scopes=['https://www.googleapis.com/auth/androidpublisher']
        )
        
        # Build the service
        service = build('androidpublisher', 'v3', credentials=credentials)
        print("✅ Successfully authenticated with Google Play API", file=sys.stderr)
        
        # Create an edit session
        print("\nCreating edit session...", file=sys.stderr)
        edit_request = service.edits().insert(body={}, packageName=package_name)
        edit_result = edit_request.execute()
        edit_id = edit_result['id']
        print(f"✅ Edit session created: {edit_id}", file=sys.stderr)
        
        # Check the internal track
        print("", file=sys.stderr)
        print("Fetching internal track from Google Play Console...", file=sys.stderr)
        
        try:
            track_result = service.edits().tracks().get(
                packageName=package_name,
                editId=edit_id,
                track='internal'
            ).execute()
        except Exception as e:
            if 'notFound' in str(e).lower():
                print("✅ No internal track found - need to build fresh", file=sys.stderr)
                return ('BUILD', 'No internal track exists')
            raise
        
        # Check releases in internal track
        releases = track_result.get('releases', [])
        
        if not releases:
            print("✅ No releases found in internal track - need to build fresh", file=sys.stderr)
            return ('BUILD', 'No releases in internal track')
        
        print(f"✅ Found {len(releases)} release(s) in internal track", file=sys.stderr)
        
        # Check if version code exists in any release
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
                    pass
            
            print(f"  Release: {release_name}", file=sys.stderr)
            print(f"    Status: {release_status}", file=sys.stderr)
            print(f"    Version codes: {version_codes_int}", file=sys.stderr)
            
            # Check if version code exists
            if version_code in version_codes_int:
                print(f"\n✅ Found version code {version_code} in internal track!", file=sys.stderr)
                print(f"   Release name: {release_name}", file=sys.stderr)
                print(f"   Status: {release_status}", file=sys.stderr)
                print(f"\n→ Action: PROMOTE from internal to production", file=sys.stderr)
                return ('PROMOTE', f'Version {version_code} found in internal track (release: {release_name}, status: {release_status})')
        
        # Version code not found in internal track
        print(f"\n⚠️ Version code {version_code} NOT found in internal track", file=sys.stderr)
        print(f"→ Action: BUILD fresh and upload to production", file=sys.stderr)
        return ('BUILD', f'Version {version_code} not found in internal track')
    
    except Exception as e:
        print(f"\n❌ Error checking internal track: {str(e)}", file=sys.stderr)
        print(f"Error type: {type(e).__name__}", file=sys.stderr)
        print("\n→ Defaulting to BUILD action due to error", file=sys.stderr)
        return ('BUILD', f'Error: {str(e)}')


def main():
    """Main entry point"""
    if len(sys.argv) != 5:
        print("Usage: python3 promote_or_build_android.py <package_name> <version_code> <version_name> <service_account_json_path>", file=sys.stderr)
        sys.exit(1)
    
    package_name = sys.argv[1]
    try:
        version_code = int(sys.argv[2])
    except ValueError:
        print(f"❌ ERROR: Version code must be an integer, got: {sys.argv[2]}", file=sys.stderr)
        sys.exit(1)
    
    version_name = sys.argv[3]
    service_account_path = sys.argv[4]
    
    # Check if version exists in internal track
    action, message = check_internal_track(package_name, version_code, version_name, service_account_path)
    
    # Output the action to stdout (for GitHub Actions to capture)
    print(action)
    
    # Output details to stderr
    print(f"\n{'='*60}", file=sys.stderr)
    print(f"Result: {action}", file=sys.stderr)
    print(f"Details: {message}", file=sys.stderr)
    print(f"{'='*60}", file=sys.stderr)
    
    sys.exit(0)


if __name__ == '__main__':
    main()
