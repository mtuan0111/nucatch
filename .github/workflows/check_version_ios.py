#!/usr/bin/env python3
"""
iOS Version Checker for App Store Connect

This script checks if a given build number already exists in App Store Connect
to prevent duplicate version uploads. It also generates JWT tokens for authentication.

Usage:
    python3 check_version_ios.py <bundle_id> <version_name> <build_number> <key_id> <issuer_id> <key_path>

Returns:
    0 - Build number is available (not found in App Store Connect)
    1 - Build number already exists in App Store Connect
    0 - Error occurred but continuing (with warning)
"""

import sys
import json
import time
import requests
from pathlib import Path


def generate_jwt_token(key_id, issuer_id, key_path):
    """
    Generate JWT token for App Store Connect API authentication.
    
    Args:
        key_id: App Store Connect API Key ID (10 characters)
        issuer_id: App Store Connect API Issuer ID (UUID format)
        key_path: Path to the .p8 private key file
    
    Returns:
        str: JWT token
    """
    try:
        import jwt
    except ImportError:
        print("❌ ERROR: PyJWT library is not installed")
        print("Installing PyJWT...")
        import subprocess
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "--quiet", "--user", "PyJWT", "cryptography"])
            import jwt
            print("✅ PyJWT installed successfully")
        except Exception as e:
            print(f"❌ Failed to install PyJWT: {e}")
            raise
    
    print(f"Generating JWT token...")
    print(f"Key ID: {key_id}")
    print(f"Issuer ID: {issuer_id}")
    print(f"Key Path: {key_path}")
    
    # Read the private key
    try:
        with open(key_path, 'r') as f:
            private_key = f.read()
    except FileNotFoundError:
        print(f"❌ ERROR: Private key file not found: {key_path}")
        raise
    except Exception as e:
        print(f"❌ ERROR: Failed to read private key: {e}")
        raise
    
    # Validate key format
    if "-----BEGIN PRIVATE KEY-----" not in private_key:
        print("❌ ERROR: Private key is not in correct PEM format")
        print("Expected to start with: -----BEGIN PRIVATE KEY-----")
        raise ValueError("Invalid private key format")
    
    if "-----END PRIVATE KEY-----" not in private_key:
        print("❌ ERROR: Private key is missing end marker")
        print("Expected to end with: -----END PRIVATE KEY-----")
        raise ValueError("Invalid private key format")
    
    print("✅ Private key loaded and validated")
    
    # Generate JWT token
    issued_at = int(time.time())
    expiration = issued_at + 1200  # Token valid for 20 minutes
    
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
    
    try:
        token = jwt.encode(payload, private_key, algorithm='ES256', headers=headers)
        # PyJWT 2.x returns string, 1.x returns bytes
        if isinstance(token, bytes):
            token = token.decode('utf-8')
        
        print(f"✅ JWT token generated successfully")
        print(f"   Token length: {len(token)} characters")
        print(f"   Token preview: {token[:30]}...{token[-30:]}")
        return token
    except Exception as e:
        print(f"❌ ERROR: Failed to generate JWT token: {e}")
        raise


def check_version(bundle_id, version_name, build_number, key_id, issuer_id, key_path):
    """
    Check if the build number exists in App Store Connect.
    
    Args:
        bundle_id: iOS bundle identifier (e.g., com.example.app)
        version_name: Version name string (for display only)
        build_number: Build number to check
        key_id: App Store Connect API Key ID
        issuer_id: App Store Connect API Issuer ID
        key_path: Path to the .p8 private key file
    
    Returns:
        bool: True if build exists, False if available
    """
    print(f"=== App Store Connect Version Checker ===")
    print(f"Bundle ID: {bundle_id}")
    print(f"Checking for build number: {build_number}")
    print(f"Version name: {version_name}")
    print("")
    
    try:
        # Generate JWT token
        print("Authenticating with App Store Connect API...")
        jwt_token = generate_jwt_token(key_id, issuer_id, key_path)
        
        # Set up headers
        headers = {
            'Authorization': f'Bearer {jwt_token}',
            'Content-Type': 'application/json'
        }
        print("✅ Successfully authenticated with App Store Connect API")
        
        # Get app information
        print("")
        print("Fetching app information from App Store Connect...")
        print(f"Searching for bundle ID: {bundle_id}")
        
        app_url = f"https://api.appstoreconnect.apple.com/v1/apps?filter[bundleId]={bundle_id}"
        
        try:
            app_response = requests.get(app_url, headers=headers, timeout=30)
        except requests.exceptions.RequestException as e:
            print(f"⚠️ Warning: Failed to connect to App Store Connect API: {e}")
            print("Proceeding with build (unable to verify version)...")
            return False
        
        print(f"HTTP Status: {app_response.status_code}")
        
        if app_response.status_code != 200:
            print(f"❌ ERROR: Failed to fetch app information (HTTP {app_response.status_code})")
            print(f"Response: {app_response.text}")
            
            # Provide specific guidance based on error
            if app_response.status_code == 401:
                print("")
                print("🔍 Authentication troubleshooting guide:")
                print("1. Verify APP_STORE_CONNECT_API_KEY_ID matches the Key ID in App Store Connect")
                print("2. Verify APP_STORE_CONNECT_API_ISSUER_ID matches the Issuer ID in App Store Connect")
                print("3. Ensure APP_STORE_CONNECT_API_KEY_CONTENT is base64-encoded correctly")
                print("4. Check that the API key hasn't been revoked in App Store Connect")
                print("5. Verify the API key has appropriate permissions (App Manager or Developer)")
            elif app_response.status_code == 403:
                print("")
                print("🔍 Authorization issue: The API key may not have sufficient permissions")
                print("Go to App Store Connect → Users and Access → Integrations → App Store Connect API")
                print("Ensure your API key has 'App Manager' or 'Developer' role")
            elif app_response.status_code == 404:
                print("")
                print(f"🔍 App not found: Bundle ID '{bundle_id}' may not exist in App Store Connect")
                print("1. Check if the app exists in App Store Connect")
                print("2. Verify the bundle identifier is correct")
                print("3. Ensure the API key has access to this app")
            
            print("Proceeding with build (unable to verify version)...")
            return False
        
        app_data = app_response.json()
        
        if not app_data.get('data'):
            print("⚠️ Warning: Could not find app in App Store Connect. This might be a new app.")
            print("Proceeding with build...")
            return False
        
        app_id = app_data['data'][0]['id']
        print(f"✅ Found app ID: {app_id}")
        
        # Get existing builds for this app
        print("")
        print("Fetching builds from App Store Connect...")
        print(f"Checking if build number {build_number} already exists...")
        
        # Query builds filtered by app and version (build number)
        builds_url = f"https://api.appstoreconnect.apple.com/v1/builds?filter[app]={app_id}&filter[version]={build_number}&limit=200"
        
        try:
            builds_response = requests.get(builds_url, headers=headers, timeout=30)
        except requests.exceptions.RequestException as e:
            print(f"⚠️ Warning: Failed to fetch builds: {e}")
            print("Proceeding with build (unable to verify build number)...")
            return False
        
        print(f"HTTP Status: {builds_response.status_code}")
        
        if builds_response.status_code != 200:
            print(f"⚠️ Warning: Failed to fetch builds from App Store Connect (HTTP {builds_response.status_code})")
            print(f"Response: {builds_response.text}")
            print("Proceeding with build (unable to verify build number)...")
            return False
        
        builds_data = builds_response.json()
        
        # Check if build number already exists
        existing_builds = builds_data.get('data', [])
        
        if existing_builds:
            # Found matching build number
            print("")
            print(f"{'='*60}")
            print(f"❌ ERROR: BUILD NUMBER ALREADY EXISTS")
            print(f"{'='*60}")
            print(f"   Build number {build_number} is ALREADY IN USE in App Store Connect")
            print(f"   App Store Connect does NOT allow duplicate build numbers!")
            print(f"")
            print(f"   Existing builds with build number {build_number}:")
            for build in existing_builds[:5]:
                attrs = build.get('attributes', {})
                version = attrs.get('version', 'N/A')
                processing_state = attrs.get('processingState', 'N/A')
                uploaded_date = attrs.get('uploadedDate', 'N/A')
                print(f"     - Build {version} | Status: {processing_state} | Uploaded: {uploaded_date}")
            
            print(f"")
            print(f"   ⚠️  Action Required:")
            print(f"   Please increment the build number in .github/config/version-config.json")
            print(f"")
            print(f"{'='*60}")
            print(f"❌ BUILD FAILED: Cannot upload duplicate build number to App Store Connect")
            print(f"{'='*60}")
            return True
        
        # Fetch recent builds for reference (without version filter)
        print("")
        print("Fetching recent builds for validation...")
        recent_builds_url = f"https://api.appstoreconnect.apple.com/v1/builds?filter[app]={app_id}&limit=10&sort=-uploadedDate"
        
        latest_build_number = None
        try:
            recent_response = requests.get(recent_builds_url, headers=headers, timeout=30)
            if recent_response.status_code == 200:
                recent_data = recent_response.json()
                recent_builds = recent_data.get('data', [])
                
                if recent_builds:
                    print(f"✅ Found {len(recent_builds)} recent builds")
                    
                    # Get the latest build number
                    latest_build_attrs = recent_builds[0].get('attributes', {})
                    latest_build_number = latest_build_attrs.get('version', None)
                    
                    # Try to convert to int for comparison
                    try:
                        if latest_build_number:
                            latest_build_int = int(latest_build_number)
                            build_number_int = int(build_number)
                            
                            # Check if build number is greater than latest
                            if build_number_int <= latest_build_int:
                                print(f"\n{'='*60}")
                                print(f"❌ ERROR: BUILD NUMBER TOO LOW")
                                print(f"{'='*60}")
                                print(f"   Build number {build_number} is NOT GREATER than existing builds")
                                print(f"   App Store Connect requires build numbers to be STRICTLY INCREASING!")
                                print(f"")
                                print(f"   Latest build number in App Store Connect: {latest_build_number}")
                                print(f"   Your build number: {build_number}")
                                print(f"   Difference: {build_number_int - latest_build_int} (Must be positive!)")
                                print(f"")
                                print(f"   ⚠️  Action Required:")
                                print(f"   Please use a build number GREATER than {latest_build_number}")
                                print(f"   Suggested next build number: {latest_build_int + 1}")
                                print(f"\n{'='*60}")
                                print(f"=== Recent builds in App Store Connect ===")
                                print(f"{'='*60}")
                                for i, build in enumerate(recent_builds[:5], 1):
                                    attrs = build.get('attributes', {})
                                    version = attrs.get('version', 'N/A')
                                    processing_state = attrs.get('processingState', 'N/A')
                                    marker = " ← Your build (TOO LOW!)" if version == build_number else ""
                                    status = " [Current]" if i == 1 else ""
                                    print(f"  {i}. Build {version} - {processing_state}{status}{marker}")
                                
                                print(f"\n{'='*60}")
                                print(f"❌ BUILD FAILED: Build number must be greater than {latest_build_number}")
                                print(f"{'='*60}")
                                return True
                    except (ValueError, TypeError):
                        # Build numbers are not numeric, skip comparison
                        print("⚠️ Build numbers are not numeric, skipping increment check")
                else:
                    print("✅ No existing builds found - this is the first build")
        except Exception as e:
            print(f"⚠️ Could not fetch recent builds: {e}")
        
        # Build number is valid
        print(f"\n{'='*60}")
        print(f"✅ VERSION VALIDATION SUCCESSFUL")
        print(f"{'='*60}")
        print(f"   Build number {build_number}: AVAILABLE ✓")
        print(f"   Version name '{version_name}': AVAILABLE ✓")
        print(f"")
        if latest_build_number:
            try:
                latest_build_int = int(latest_build_number)
                build_number_int = int(build_number)
                print(f"   Latest build number in App Store Connect: {latest_build_number}")
                print(f"   Your build number: {build_number}")
                print(f"   Difference: +{build_number_int - latest_build_int} (Valid ✓)")
            except (ValueError, TypeError):
                print(f"   Latest build number in App Store Connect: {latest_build_number}")
                print(f"   Your build number: {build_number}")
        else:
            print(f"   No existing build numbers found - this is the first release")
        print(f"")
        print(f"   ✅ Validation successful - proceeding with build")
        print(f"{'='*60}")
        return False
    
    except Exception as e:
        print(f"\n⚠️ Warning: Failed to validate version")
        print(f"Error: {str(e)}")
        print(f"Error type: {type(e).__name__}")
        print("\nProceeding with build (unable to verify version)...")
        return False


def main():
    """Main entry point"""
    if len(sys.argv) != 7:
        print("Usage: python3 check_version_ios.py <bundle_id> <version_name> <build_number> <key_id> <issuer_id> <key_path>")
        print("")
        print("Arguments:")
        print("  bundle_id: iOS bundle identifier (e.g., com.example.app)")
        print("  version_name: Version name (e.g., 1.0.0)")
        print("  build_number: Build number to check (e.g., 123)")
        print("  key_id: App Store Connect API Key ID (10 characters)")
        print("  issuer_id: App Store Connect API Issuer ID (UUID format)")
        print("  key_path: Path to the .p8 private key file")
        sys.exit(1)
    
    bundle_id = sys.argv[1]
    version_name = sys.argv[2]
    build_number = sys.argv[3]
    key_id = sys.argv[4]
    issuer_id = sys.argv[5]
    key_path = sys.argv[6]
    
    # Validate inputs
    if len(key_id) != 10:
        print(f"⚠️ WARNING: APP_STORE_CONNECT_API_KEY_ID has unexpected length: {len(key_id)} (expected: 10)")
        print(f"   Key ID: {key_id}")
    
    # Issuer ID should be UUID format (8-4-4-4-12 characters)
    import re
    if not re.match(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', issuer_id.lower()):
        print(f"⚠️ WARNING: APP_STORE_CONNECT_API_ISSUER_ID doesn't match UUID format")
        print(f"   Issuer ID: {issuer_id}")
        print(f"   Expected format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
    
    # Check if build exists
    build_exists = check_version(bundle_id, version_name, build_number, key_id, issuer_id, key_path)
    
    # Exit with appropriate code
    if build_exists:
        sys.exit(1)  # Build exists - fail the build
    else:
        sys.exit(0)  # Build available or error (continue)


if __name__ == '__main__':
    main()
