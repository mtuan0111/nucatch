#!/usr/bin/env python3
"""
Android Promote or Build Checker for Google Play Console

This script checks if a given version code already exists as an app bundle
in Google Play Console (across all tracks: internal, alpha, beta, production).
If it exists, it returns PROMOTE. Otherwise, it returns BUILD.

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


TRACKS_TO_CHECK = ['internal', 'alpha', 'beta', 'production']


def check_bundle_exists(package_name, version_code, version_name, service_account_path):
    """
    Check if the version code exists as an app bundle in any Google Play track.
    
    Args:
        package_name: Android package name (e.g., com.example.app)
        version_code: Integer version code to check
        version_name: Version name string (for display only)
        service_account_path: Path to service account JSON file
    
    Returns:
        tuple: (action, message, found_track) where action is 'PROMOTE' or 'BUILD'
    """
    print(f"=== Google Play Console App Bundle Checker ===", file=sys.stderr)
    print(f"Package name: {package_name}", file=sys.stderr)
    print(f"Checking for version code: {version_code}", file=sys.stderr)
    print(f"Version name: {version_name}", file=sys.stderr)
    print(f"Tracks to check: {', '.join(TRACKS_TO_CHECK)}", file=sys.stderr)
    print("", file=sys.stderr)
    
    try:
        # Authenticate with service account
        print("Authenticating with Google Play API...", file=sys.stderr)
        credentials = service_account.Credentials.from_service_account_file(
            service_account_path,
            scopes=['https://www.googleapis.com/auth/androidpublisher']
        )
        
        service = build('androidpublisher', 'v3', credentials=credentials)
        print("✅ Successfully authenticated with Google Play API", file=sys.stderr)
        
        # Create an edit session
        print("\nCreating edit session...", file=sys.stderr)
        edit_request = service.edits().insert(body={}, packageName=package_name)
        edit_result = edit_request.execute()
        edit_id = edit_result['id']
        print(f"✅ Edit session created: {edit_id}", file=sys.stderr)
        
        # Check all tracks for the version code
        print(f"\nSearching for version code {version_code} across all tracks...", file=sys.stderr)
        
        for track_name in TRACKS_TO_CHECK:
            print(f"\n--- Checking '{track_name}' track ---", file=sys.stderr)
            
            try:
                track_result = service.edits().tracks().get(
                    packageName=package_name,
                    editId=edit_id,
                    track=track_name
                ).execute()
            except Exception as e:
                if 'notFound' in str(e).lower() or '404' in str(e):
                    print(f"  No '{track_name}' track found, skipping", file=sys.stderr)
                    continue
                print(f"  ⚠️ Error reading '{track_name}' track: {e}", file=sys.stderr)
                continue
            
            releases = track_result.get('releases', [])
            
            if not releases:
                print(f"  No releases in '{track_name}' track", file=sys.stderr)
                continue
            
            print(f"  Found {len(releases)} release(s)", file=sys.stderr)
            
            for release in releases:
                release_name = release.get('name', 'Unnamed')
                release_status = release.get('status', 'unknown')
                version_codes = release.get('versionCodes', [])
                
                version_codes_int = []
                for vc in version_codes:
                    try:
                        version_codes_int.append(int(vc))
                    except (ValueError, TypeError):
                        pass
                
                print(f"    Release: {release_name} (status: {release_status})", file=sys.stderr)
                print(f"    Version codes: {version_codes_int}", file=sys.stderr)
                
                if version_code in version_codes_int:
                    print(f"\n✅ Found version code {version_code} in '{track_name}' track!", file=sys.stderr)
                    print(f"   Release: {release_name}, Status: {release_status}", file=sys.stderr)
                    print(f"\n→ Action: PROMOTE to production", file=sys.stderr)
                    return (
                        'PROMOTE',
                        f'Version {version_code} found in {track_name} track (release: {release_name}, status: {release_status})',
                        track_name
                    )
        
        # Version code not found in any track
        print(f"\n⚠️ Version code {version_code} NOT found in any track", file=sys.stderr)
        print(f"→ Action: BUILD fresh and upload to production", file=sys.stderr)
        return ('BUILD', f'Version {version_code} not found in any track', None)
    
    except Exception as e:
        print(f"\n❌ Error checking tracks: {str(e)}", file=sys.stderr)
        print(f"Error type: {type(e).__name__}", file=sys.stderr)
        print("\n→ Defaulting to BUILD action due to error", file=sys.stderr)
        return ('BUILD', f'Error: {str(e)}', None)


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
    
    action, message, found_track = check_bundle_exists(package_name, version_code, version_name, service_account_path)
    
    # Output the action to stdout (for GitHub Actions to capture)
    print(action)
    
    # Output details to stderr
    print(f"\n{'='*60}", file=sys.stderr)
    print(f"Result: {action}", file=sys.stderr)
    print(f"Details: {message}", file=sys.stderr)
    if found_track:
        print(f"Source track: {found_track}", file=sys.stderr)
    print(f"{'='*60}", file=sys.stderr)
    
    sys.exit(0)


if __name__ == '__main__':
    main()
