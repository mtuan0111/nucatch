#!/usr/bin/env python3
"""
Automatically Submit iOS App to App Store for Review

This script uses the App Store Connect API to:
1. Wait for the build to be processed by Apple
2. Create a new App Store version (if needed)
3. Add the build to the version
4. Set release notes
5. Submit for review

Usage:
    python3 submit_to_app_store.py <bundle_id> <version_name> <build_number> \
        <api_key_id> <issuer_id> <api_key_path> <release_notes_json>

Example:
    python3 submit_to_app_store.py com.example.app 1.0.0 100 \
        ABC123 DEF456 /path/to/key.p8 '{"en-US":"Release notes"}'
"""

import sys
import json
import time
import jwt
import requests
from datetime import datetime, timedelta
from pathlib import Path


class AppStoreConnectAPI:
    """Handler for App Store Connect API interactions."""
    
    BASE_URL = "https://api.appstoreconnect.apple.com/v1"
    
    def __init__(self, key_id, issuer_id, key_path):
        """Initialize API client with credentials."""
        self.key_id = key_id
        self.issuer_id = issuer_id
        self.key_path = key_path
        
    def generate_token(self):
        """Generate JWT token for API authentication."""
        with open(self.key_path, 'r') as key_file:
            private_key = key_file.read()
        
        headers = {
            "alg": "ES256",
            "kid": self.key_id,
            "typ": "JWT"
        }
        
        payload = {
            "iss": self.issuer_id,
            "exp": datetime.utcnow() + timedelta(minutes=20),
            "aud": "appstoreconnect-v1"
        }
        
        return jwt.encode(payload, private_key, algorithm="ES256", headers=headers)
    
    def make_request(self, method, endpoint, data=None, params=None):
        """Make authenticated API request."""
        token = self.generate_token()
        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }
        
        url = f"{self.BASE_URL}{endpoint}"
        
        if method == "GET":
            response = requests.get(url, headers=headers, params=params)
        elif method == "POST":
            response = requests.post(url, headers=headers, json=data)
        elif method == "PATCH":
            response = requests.patch(url, headers=headers, json=data)
        else:
            raise ValueError(f"Unsupported method: {method}")
        
        if response.status_code not in [200, 201]:
            print(f"❌ API Error ({response.status_code}): {response.text}")
            raise Exception(f"API request failed: {response.status_code}")
        
        return response.json()
    
    def get_app_id(self, bundle_id):
        """Get app ID from bundle identifier."""
        print(f"🔍 Looking up app ID for bundle: {bundle_id}")
        
        params = {
            "filter[bundleId]": bundle_id,
            "limit": 1
        }
        
        response = self.make_request("GET", "/apps", params=params)
        
        if not response.get("data"):
            raise Exception(f"App not found for bundle ID: {bundle_id}")
        
        app_id = response["data"][0]["id"]
        app_name = response["data"][0]["attributes"]["name"]
        print(f"✅ Found app: {app_name} (ID: {app_id})")
        
        return app_id
    
    def wait_for_build(self, bundle_id, version_name, build_number, max_wait_minutes=30):
        """Wait for build to be processed by Apple."""
        print(f"\n⏳ Waiting for build {version_name} ({build_number}) to be processed...")
        print(f"   This usually takes 5-15 minutes. Max wait: {max_wait_minutes} minutes")
        
        start_time = time.time()
        max_wait_seconds = max_wait_minutes * 60
        check_interval = 30  # Check every 30 seconds
        
        while (time.time() - start_time) < max_wait_seconds:
            try:
                params = {
                    "filter[version]": build_number,
                    "filter[app]": self.get_app_id(bundle_id),
                    "limit": 1
                }
                
                response = self.make_request("GET", "/builds", params=params)
                
                if response.get("data"):
                    build_data = response["data"][0]
                    processing_state = build_data["attributes"].get("processingState")
                    
                    elapsed = int(time.time() - start_time)
                    minutes = elapsed // 60
                    seconds = elapsed % 60
                    
                    if processing_state == "VALID":
                        print(f"✅ Build is ready! (waited {minutes}m {seconds}s)")
                        return build_data["id"]
                    elif processing_state == "INVALID":
                        raise Exception("Build processing failed - build marked as INVALID")
                    else:
                        print(f"   Build status: {processing_state} (elapsed: {minutes}m {seconds}s)")
                
            except Exception as e:
                print(f"   Check failed: {e}")
            
            time.sleep(check_interval)
        
        raise Exception(f"Build not ready after {max_wait_minutes} minutes")
    
    def get_or_create_version(self, app_id, version_string):
        """Get existing version or create new one."""
        print(f"\n📋 Checking for App Store version {version_string}...")
        
        # Check if version exists
        params = {
            "filter[app]": app_id,
            "filter[versionString]": version_string,
            "filter[platform]": "IOS",
            "limit": 1
        }
        
        response = self.make_request("GET", "/appStoreVersions", params=params)
        
        if response.get("data"):
            version_id = response["data"][0]["id"]
            state = response["data"][0]["attributes"]["appStoreState"]
            print(f"✅ Version exists (ID: {version_id}, State: {state})")
            return version_id, state
        
        # Create new version
        print(f"📝 Creating new App Store version {version_string}...")
        
        data = {
            "data": {
                "type": "appStoreVersions",
                "attributes": {
                    "platform": "IOS",
                    "versionString": version_string
                },
                "relationships": {
                    "app": {
                        "data": {
                            "type": "apps",
                            "id": app_id
                        }
                    }
                }
            }
        }
        
        response = self.make_request("POST", "/appStoreVersions", data=data)
        version_id = response["data"]["id"]
        print(f"✅ Created version (ID: {version_id})")
        
        return version_id, "PREPARE_FOR_SUBMISSION"
    
    def set_build_for_version(self, version_id, build_id):
        """Associate build with App Store version."""
        print(f"\n🔗 Linking build to version...")
        
        data = {
            "data": {
                "type": "builds",
                "id": build_id
            }
        }
        
        self.make_request("PATCH", f"/appStoreVersions/{version_id}/relationships/build", data=data)
        print(f"✅ Build linked to version")
    
    def set_release_notes(self, version_id, release_notes_dict):
        """Set localized release notes (What's New)."""
        print(f"\n📝 Setting release notes for {len(release_notes_dict)} locale(s)...")
        
        for locale, notes in release_notes_dict.items():
            # Get or create localization
            params = {
                "filter[appStoreVersion]": version_id,
                "filter[locale]": locale,
                "limit": 1
            }
            
            response = self.make_request("GET", "/appStoreVersionLocalizations", params=params)
            
            if response.get("data"):
                # Update existing localization
                localization_id = response["data"][0]["id"]
                data = {
                    "data": {
                        "type": "appStoreVersionLocalizations",
                        "id": localization_id,
                        "attributes": {
                            "whatsNew": notes
                        }
                    }
                }
                self.make_request("PATCH", f"/appStoreVersionLocalizations/{localization_id}", data=data)
                print(f"   ✅ Updated {locale}: {notes[:50]}...")
            else:
                # Create new localization
                data = {
                    "data": {
                        "type": "appStoreVersionLocalizations",
                        "attributes": {
                            "locale": locale,
                            "whatsNew": notes
                        },
                        "relationships": {
                            "appStoreVersion": {
                                "data": {
                                    "type": "appStoreVersions",
                                    "id": version_id
                                }
                            }
                        }
                    }
                }
                self.make_request("POST", "/appStoreVersionLocalizations", data=data)
                print(f"   ✅ Created {locale}: {notes[:50]}...")
    
    def submit_for_review(self, version_id):
        """Submit version for App Store review."""
        print(f"\n🚀 Submitting for App Store review...")
        
        data = {
            "data": {
                "type": "appStoreVersionSubmissions",
                "relationships": {
                    "appStoreVersion": {
                        "data": {
                            "type": "appStoreVersions",
                            "id": version_id
                        }
                    }
                }
            }
        }
        
        try:
            response = self.make_request("POST", "/appStoreVersionSubmissions", data=data)
            print(f"✅ Successfully submitted for review!")
            return True
        except Exception as e:
            print(f"❌ Submission failed: {e}")
            print(f"   This may happen if the version is already submitted or requires manual intervention.")
            return False


def main():
    """Main execution function."""
    if len(sys.argv) != 8:
        print("Usage: python3 submit_to_app_store.py <bundle_id> <version_name> <build_number> "
              "<api_key_id> <issuer_id> <api_key_path> <release_notes_json>")
        sys.exit(1)
    
    bundle_id = sys.argv[1]
    version_name = sys.argv[2]
    build_number = sys.argv[3]
    api_key_id = sys.argv[4]
    issuer_id = sys.argv[5]
    api_key_path = sys.argv[6]
    release_notes_json = sys.argv[7]
    
    try:
        release_notes = json.loads(release_notes_json)
    except json.JSONDecodeError:
        print(f"❌ Invalid JSON for release notes: {release_notes_json}")
        sys.exit(1)
    
    print("=" * 70)
    print("📱 AUTOMATIC APP STORE SUBMISSION")
    print("=" * 70)
    print(f"Bundle ID: {bundle_id}")
    print(f"Version: {version_name}")
    print(f"Build: {build_number}")
    print(f"Release Notes: {len(release_notes)} locale(s)")
    print("=" * 70)
    
    try:
        # Initialize API client
        api = AppStoreConnectAPI(api_key_id, issuer_id, api_key_path)
        
        # Get app ID
        app_id = api.get_app_id(bundle_id)
        
        # Wait for build to be processed
        build_id = api.wait_for_build(bundle_id, version_name, build_number)
        
        # Get or create version
        version_id, version_state = api.get_or_create_version(app_id, version_name)
        
        # Check if already submitted
        if version_state in ["WAITING_FOR_REVIEW", "IN_REVIEW", "PENDING_DEVELOPER_RELEASE", "READY_FOR_SALE"]:
            print(f"\n⚠️  Version is already in state: {version_state}")
            print(f"   Skipping submission (already submitted or released)")
            sys.exit(0)
        
        # Set build for version
        api.set_build_for_version(version_id, build_id)
        
        # Set release notes
        api.set_release_notes(version_id, release_notes)
        
        # Submit for review
        success = api.submit_for_review(version_id)
        
        if success:
            print("\n" + "=" * 70)
            print("✅ APP STORE SUBMISSION COMPLETED SUCCESSFULLY!")
            print("=" * 70)
            print(f"\n📋 Next Steps:")
            print(f"   • Apple will review your app (typically 1-3 days)")
            print(f"   • Check status in App Store Connect")
            print(f"   • You'll receive email notifications about review progress")
            print(f"\n🔗 View in App Store Connect:")
            print(f"   https://appstoreconnect.apple.com/apps/{app_id}/appstore")
            print()
        else:
            print("\n⚠️  Submission could not be completed automatically.")
            print("   Please check App Store Connect and submit manually if needed.")
            sys.exit(1)
            
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
