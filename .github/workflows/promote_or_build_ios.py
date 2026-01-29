#!/usr/bin/env python3
"""
iOS Promote or Build Checker for App Store Connect

This script checks if a given build number already exists in TestFlight.
If it exists, it returns PROMOTE to indicate the build should be submitted
directly to App Store Review. Otherwise, it returns BUILD.

Usage:
    python3 promote_or_build_ios.py <bundle_id> <version_name> <build_number> <key_id> <issuer_id> <key_path>

Returns:
    0 - Success (outputs PROMOTE or BUILD to stdout)
    1 - Error occurred
"""

import sys
import json
import time
import requests


def generate_jwt_token(key_id, issuer_id, key_path):
    """Generate JWT token for App Store Connect API authentication."""
    try:
        import jwt
    except ImportError:
        print("Installing PyJWT...", file=sys.stderr)
        import subprocess
        subprocess.check_call([sys.executable, "-m", "pip", "install", "--quiet", "--user", "PyJWT", "cryptography"])
        import jwt
    
    print(f"Generating JWT token...", file=sys.stderr)
    
    with open(key_path, 'r') as f:
        private_key = f.read()
    
    issued_at = int(time.time())
    expiration = issued_at + 1200  # 20 minutes
    
    payload = {
        'iss': issuer_id,
        'iat': issued_at,
        'exp': expiration,
        'aud': 'appstoreconnect-v1'
    }
    
    headers = {
        'alg': 'ES256',
        'kid': key_id,
        'typ': 'JWT'
    }
    
    token = jwt.encode(payload, private_key, algorithm='ES256', headers=headers)
    if isinstance(token, bytes):
        token = token.decode('utf-8')
    
    print(f"✅ JWT token generated successfully", file=sys.stderr)
    return token


def check_testflight(bundle_id, version_name, build_number, key_id, issuer_id, key_path):
    """
    Check if the build number exists in TestFlight.
    
    Returns:
        tuple: (action, message) where action is 'PROMOTE' or 'BUILD'
    """
    print(f"=== App Store Connect TestFlight Checker ===", file=sys.stderr)
    print(f"Bundle ID: {bundle_id}", file=sys.stderr)
    print(f"Checking for build number: {build_number}", file=sys.stderr)
    print(f"Version name: {version_name}", file=sys.stderr)
    print("", file=sys.stderr)
    
    try:
        # Generate JWT token
        print("Authenticating with App Store Connect API...", file=sys.stderr)
        jwt_token = generate_jwt_token(key_id, issuer_id, key_path)
        
        headers = {
            'Authorization': f'Bearer {jwt_token}',
            'Content-Type': 'application/json'
        }
        print("✅ Successfully authenticated", file=sys.stderr)
        
        # Get app information
        print("\nFetching app information...", file=sys.stderr)
        app_url = f"https://api.appstoreconnect.apple.com/v1/apps?filter[bundleId]={bundle_id}"
        
        app_response = requests.get(app_url, headers=headers, timeout=30)
        
        if app_response.status_code != 200:
            print(f"❌ Failed to fetch app info (HTTP {app_response.status_code})", file=sys.stderr)
            return ('BUILD', f'Error fetching app: HTTP {app_response.status_code}')
        
        app_data = app_response.json()
        
        if not app_data.get('data'):
            print("⚠️ App not found in App Store Connect", file=sys.stderr)
            return ('BUILD', 'App not found')
        
        app_id = app_data['data'][0]['id']
        print(f"✅ Found app ID: {app_id}", file=sys.stderr)
        
        # Check for existing build with this build number
        print(f"\nChecking TestFlight for build {build_number}...", file=sys.stderr)
        builds_url = f"https://api.appstoreconnect.apple.com/v1/builds?filter[app]={app_id}&filter[version]={build_number}&limit=10"
        
        builds_response = requests.get(builds_url, headers=headers, timeout=30)
        
        if builds_response.status_code != 200:
            print(f"⚠️ Failed to fetch builds (HTTP {builds_response.status_code})", file=sys.stderr)
            return ('BUILD', f'Error fetching builds: HTTP {builds_response.status_code}')
        
        builds_data = builds_response.json()
        existing_builds = builds_data.get('data', [])
        
        if existing_builds:
            # Found matching build number in TestFlight
            build = existing_builds[0]
            attrs = build.get('attributes', {})
            processing_state = attrs.get('processingState', 'unknown')
            uploaded_date = attrs.get('uploadedDate', 'unknown')
            
            print(f"\n✅ Found build {build_number} in TestFlight!", file=sys.stderr)
            print(f"   Processing State: {processing_state}", file=sys.stderr)
            print(f"   Uploaded: {uploaded_date}", file=sys.stderr)
            
            # Check if build is ready for submission
            if processing_state in ['VALID', 'PROCESSING']:
                print(f"\n→ Action: PROMOTE (submit to App Store Review)", file=sys.stderr)
                return ('PROMOTE', f'Build {build_number} found in TestFlight (state: {processing_state})')
            else:
                print(f"\n⚠️ Build state '{processing_state}' may not be suitable for promotion", file=sys.stderr)
                print(f"→ Action: PROMOTE (will attempt submission)", file=sys.stderr)
                return ('PROMOTE', f'Build {build_number} found (state: {processing_state})')
        
        # Build number not found in TestFlight
        print(f"\n⚠️ Build number {build_number} NOT found in TestFlight", file=sys.stderr)
        print(f"→ Action: BUILD (build and upload to TestFlight)", file=sys.stderr)
        return ('BUILD', f'Build {build_number} not found in TestFlight')
    
    except Exception as e:
        print(f"\n❌ Error checking TestFlight: {str(e)}", file=sys.stderr)
        print(f"→ Defaulting to BUILD action", file=sys.stderr)
        return ('BUILD', f'Error: {str(e)}')


def main():
    """Main entry point"""
    if len(sys.argv) != 7:
        print("Usage: python3 promote_or_build_ios.py <bundle_id> <version_name> <build_number> <key_id> <issuer_id> <key_path>", file=sys.stderr)
        sys.exit(1)
    
    bundle_id = sys.argv[1]
    version_name = sys.argv[2]
    build_number = sys.argv[3]
    key_id = sys.argv[4]
    issuer_id = sys.argv[5]
    key_path = sys.argv[6]
    
    # Check if build exists in TestFlight
    action, message = check_testflight(bundle_id, version_name, build_number, key_id, issuer_id, key_path)
    
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
