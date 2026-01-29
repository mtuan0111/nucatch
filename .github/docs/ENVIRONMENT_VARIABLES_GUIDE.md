# Environment Variables Setup Guide

This document provides detailed instructions on how to obtain and configure all the secrets and variables required for the NuCatch CI/CD workflows.

---

## Table of Contents

1. [Overview](#overview)
2. [GitHub Repository Configuration](#github-repository-configuration)
3. [Android Secrets](#android-secrets)
4. [iOS Secrets](#ios-secrets)
5. [Repository Variables](#repository-variables)
6. [Troubleshooting](#troubleshooting)

---

## Overview

The CI/CD workflows require the following credentials configured in GitHub:

| Type | Count | Description |
|------|-------|-------------|
| **Secrets** | 12 | Sensitive data like keystores, certificates, API keys |
| **Variables** | 6 | Non-sensitive configuration like package names |

> [!IMPORTANT]
> All secrets must be configured in **GitHub → Repository Settings → Secrets and variables → Actions** before the workflows can run.

---

## GitHub Repository Configuration

### Environments

Create two environments in your GitHub repository:

1. **development** - For internal testing deployments
2. **production** - For production releases

Go to: `Settings → Environments → New environment`

---

## Android Secrets

### 1. KEYSTORE_BASE64 / KEYSTORE_BASE64_PRD

**What it is:** Base64-encoded Android keystore file (.jks or .keystore)

**How to create:**

```bash
# Generate a new keystore (if you don't have one)
keytool -genkey -v -keystore nucatch.keystore -alias nucatch \
  -keyalg RSA -keysize 2048 -validity 10000

# Convert keystore to base64
base64 -i nucatch.keystore -o keystore_base64.txt

# Copy the content of keystore_base64.txt as the secret value
cat keystore_base64.txt
```

**Where to find existing keystore:**
- Check your project's `android/` directory
- Look for files with `.jks` or `.keystore` extension
- The NuCatch project has `upload-keystore.jks` in the root directory

**GitHub Secret Names:**
- `KEYSTORE_BASE64` - For development builds
- `KEYSTORE_BASE64_PRD` - For production builds (can be the same or different)

---

### 2. KEY_PROPERTIES_BASE64 / KEY_PROPERTIES_BASE64_PRD

**What it is:** Base64-encoded key.properties file

**How to create:**

First, create a `key.properties` file:

```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=nucatch
storeFile=nucatch.keystore
```

Then encode it:

```bash
base64 -i key.properties -o key_properties_base64.txt
cat key_properties_base64.txt
```

> [!WARNING]
> Make sure the `storeFile` path matches the keystore filename used in the workflow (`nucatch.keystore`)

**GitHub Secret Names:**
- `KEY_PROPERTIES_BASE64` - For development builds
- `KEY_PROPERTIES_BASE64_PRD` - For production builds

---

### 3. SERVICE_ACCOUNT_JSON_BASE64 / SERVICE_ACCOUNT_JSON_BASE64_PRD

**What it is:** Base64-encoded Google Cloud service account JSON file with Google Play API access

**How to create:**

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select or create a project
3. Navigate to **APIs & Services → Library**
4. Search for and enable **Google Play Android Developer API**
5. Go to **APIs & Services → Credentials**
6. Click **Create Credentials → Service Account**
7. Fill in the service account details:
   - Name: `nucatch-play-publisher`
   - Description: `Service account for NuCatch Play Store deployments`
8. Click **Create and Continue**
9. Skip the optional steps and click **Done**
10. Click on the created service account
11. Go to **Keys** tab → **Add Key → Create new key**
12. Select **JSON** and click **Create**
13. Download the JSON file

**Link the service account to Google Play Console:**

1. Go to [Google Play Console](https://play.google.com/console/)
2. Navigate to **Settings → API access**
3. Link your Google Cloud project
4. Find your service account and click **Grant access**
5. Assign the **Release Manager** or **Admin** role
6. Select the apps this account should have access to

**Encode the JSON file:**

```bash
base64 -i service_account.json -o service_account_base64.txt
cat service_account_base64.txt
```

**GitHub Secret Names:**
- `SERVICE_ACCOUNT_JSON_BASE64` - For development builds (internal testing)
- `SERVICE_ACCOUNT_JSON_BASE64_PRD` - For production builds

---

## iOS Secrets

### 4. IOS_CERTIFICATE_BASE64

**What it is:** Base64-encoded iOS Distribution Certificate (.p12 file)

**How to create:**

1. Go to [Apple Developer Portal](https://developer.apple.com/account/)
2. Navigate to **Certificates, Identifiers & Profiles → Certificates**
3. Click **+** to create a new certificate
4. Select **Apple Distribution** (for App Store distribution)
5. Follow the instructions to create a Certificate Signing Request (CSR):
   - Open **Keychain Access** on your Mac
   - Go to **Keychain Access → Certificate Assistant → Request a Certificate from a Certificate Authority**
   - Enter your email, select **Saved to disk**, click **Continue**
6. Upload the CSR file and download the certificate (.cer)
7. Double-click the .cer file to install it in Keychain Access
8. In Keychain Access, find the certificate under **My Certificates**
9. Right-click and select **Export**
10. Save as .p12 file with a password

**Encode the certificate:**

```bash
base64 -i certificate.p12 -o certificate_base64.txt
cat certificate_base64.txt
```

**GitHub Secret Name:** `IOS_CERTIFICATE_BASE64`

---

### 5. CERTIFICATE_PASSWORD

**What it is:** The password you set when exporting the .p12 certificate

**How to get:** Use the password you entered when exporting the certificate in step 10 above.

**GitHub Secret Name:** `CERTIFICATE_PASSWORD`

---

### 6. KEYCHAIN_PASSWORD

**What it is:** A password for the temporary keychain created during CI builds

**How to create:** Generate any secure random password. This is only used within the CI environment.

```bash
# Generate a random password
openssl rand -base64 24
```

**GitHub Secret Name:** `KEYCHAIN_PASSWORD`

---

### 7. IOS_PROVISIONING_PROFILE_BASE64 / IOS_PROVISIONING_PROFILE_BASE64_PRD

**What it is:** Base64-encoded iOS provisioning profile (.mobileprovision)

**How to create:**

1. Go to [Apple Developer Portal](https://developer.apple.com/account/)
2. Navigate to **Certificates, Identifiers & Profiles → Profiles**
3. Click **+** to create a new profile
4. Select **App Store Connect** (for distribution)
5. Select your App ID (bundle identifier)
6. Select your Distribution Certificate
7. Name the profile (e.g., `NuCatch_Dev_AppStore` or `NuCatch_Prd_AppStore`)
8. Download the .mobileprovision file

**Encode the profile:**

```bash
base64 -i NuCatch_Dev_AppStore.mobileprovision -o profile_base64.txt
cat profile_base64.txt
```

> [!NOTE]
> Make sure the provisioning profile filename matches the one specified in the workflow:
> - Development: `NuCatch_Dev_AppStore.mobileprovision`
> - Production: `NuCatch_Prd_AppStore.mobileprovision`

**GitHub Secret Names:**
- `IOS_PROVISIONING_PROFILE_BASE64` - For development/internal testing
- `IOS_PROVISIONING_PROFILE_BASE64_PRD` - For production releases

---

### 8. APP_STORE_CONNECT_API_KEY_CONTENT

**What it is:** Base64-encoded App Store Connect API private key (.p8 file)

**How to create:**

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Navigate to **Users and Access → Integrations → App Store Connect API**
3. Click **Generate API Key** (or use existing one)
4. Fill in:
   - Name: `NuCatch CI/CD`
   - Access: **App Manager** or **Developer**
5. Click **Generate**
6. Download the API key file (AuthKey_XXXXXXXXXX.p8)

> [!CAUTION]
> The API key can only be downloaded once! Store it securely.

**Encode the key:**

```bash
base64 -i AuthKey_XXXXXXXXXX.p8 -o api_key_base64.txt
cat api_key_base64.txt
```

**GitHub Secret Name:** `APP_STORE_CONNECT_API_KEY_CONTENT`

---

### 9. APP_STORE_CONNECT_API_ISSUER_ID

**What it is:** The Issuer ID for App Store Connect API

**How to find:**

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Navigate to **Users and Access → Integrations → App Store Connect API**
3. The Issuer ID is displayed at the top of the page (UUID format)

Example: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`

**GitHub Secret Name:** `APP_STORE_CONNECT_API_ISSUER_ID`

---

## Repository Variables

Variables are non-sensitive configuration values. Configure them in:
`Settings → Secrets and variables → Actions → Variables`

### 1. ANDROID_PACKAGE_NAME / ANDROID_PACKAGE_NAME_PRD

**What it is:** Android application package name (applicationId)

**How to find:**

Check your `android/app/build.gradle`:

```groovy
android {
    defaultConfig {
        applicationId "com.example.nucatch"
    }
}
```

**GitHub Variable Names:**
- `ANDROID_PACKAGE_NAME` - Development package (e.g., `com.example.nucatch.dev`)
- `ANDROID_PACKAGE_NAME_PRD` - Production package (e.g., `com.example.nucatch`)

---

### 2. APP_STORE_CONNECT_API_KEY_ID

**What it is:** The Key ID for App Store Connect API (10 characters)

**How to find:**

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Navigate to **Users and Access → Integrations → App Store Connect API**
3. Find your API key and copy the **Key ID** column

Example: `ABC123DEFG`

**GitHub Variable Name:** `APP_STORE_CONNECT_API_KEY_ID`

---

### 3. IOS_BUNDLE_IDENTIFIER / IOS_BUNDLE_IDENTIFIER_PRD

**What it is:** iOS application bundle identifier

**How to find:**

Check your `ios/Runner.xcodeproj/project.pbxproj` or open Xcode and look at:
**Runner → General → Bundle Identifier**

**GitHub Variable Names:**
- `IOS_BUNDLE_IDENTIFIER` - Development bundle ID (e.g., `com.example.nucatchDev`)
- `IOS_BUNDLE_IDENTIFIER_PRD` - Production bundle ID (e.g., `com.example.nucatch`)

---

## Summary Checklist

### Secrets (configure in GitHub Secrets)

| Secret Name | Environment | Description |
|-------------|-------------|-------------|
| `KEYSTORE_BASE64` | development | Android keystore (dev) |
| `KEYSTORE_BASE64_PRD` | production | Android keystore (prod) |
| `KEY_PROPERTIES_BASE64` | development | Keystore properties (dev) |
| `KEY_PROPERTIES_BASE64_PRD` | production | Keystore properties (prod) |
| `SERVICE_ACCOUNT_JSON_BASE64` | development | Google Play service account (dev) |
| `SERVICE_ACCOUNT_JSON_BASE64_PRD` | production | Google Play service account (prod) |
| `IOS_CERTIFICATE_BASE64` | both | iOS distribution certificate |
| `CERTIFICATE_PASSWORD` | both | Certificate export password |
| `KEYCHAIN_PASSWORD` | both | CI keychain password |
| `IOS_PROVISIONING_PROFILE_BASE64` | development | iOS provisioning profile (dev) |
| `IOS_PROVISIONING_PROFILE_BASE64_PRD` | production | iOS provisioning profile (prod) |
| `APP_STORE_CONNECT_API_KEY_CONTENT` | both | App Store Connect API key |
| `APP_STORE_CONNECT_API_ISSUER_ID` | both | App Store Connect Issuer ID |

### Variables (configure in GitHub Variables)

| Variable Name | Description |
|---------------|-------------|
| `ANDROID_PACKAGE_NAME` | Android package name (dev) |
| `ANDROID_PACKAGE_NAME_PRD` | Android package name (prod) |
| `APP_STORE_CONNECT_API_KEY_ID` | App Store Connect API Key ID |
| `IOS_BUNDLE_IDENTIFIER` | iOS bundle identifier (dev) |
| `IOS_BUNDLE_IDENTIFIER_PRD` | iOS bundle identifier (prod) |

---

## Troubleshooting

### "Version already exists" Error

The version code/build number already exists in the store. Update `.github/config/version-config.json`:

```bash
cd .github/scripts
./version-manager.sh android dev bump-patch
./version-manager.sh ios dev bump-patch
```

### "Service account not found" Error

1. Verify the service account is linked to Google Play Console
2. Check that it has Release Manager permissions
3. Ensure the package name matches the app in Play Console

### "Invalid provisioning profile" Error

1. Verify the provisioning profile matches the bundle identifier
2. Check that the certificate used to create the profile is the same one in `IOS_CERTIFICATE_BASE64`
3. Ensure the profile is for App Store distribution (not Ad Hoc or Development)

### "JWT token invalid" Error (iOS)

1. Verify `APP_STORE_CONNECT_API_KEY_ID` is exactly 10 characters
2. Check `APP_STORE_CONNECT_API_ISSUER_ID` is in UUID format
3. Ensure the API key has sufficient permissions in App Store Connect

---

## Quick Commands

```bash
# Check current versions
cd .github/scripts
./version-manager.sh android dev get
./version-manager.sh ios dev get

# Bump versions before release
./version-manager.sh android dev bump-patch
./version-manager.sh ios dev bump-patch

# Update release notes
./version-manager.sh android dev update-notes "New features and bug fixes"
./version-manager.sh ios dev update-notes "New features and bug fixes"

# Commit and push
git add .github/config/version-config.json
git commit -m "chore: bump version"
git push origin development
```

---

## Need Help?

- Check the workflow logs in GitHub Actions for detailed error messages
- Review the Python validation scripts in `.github/workflows/` for version checking logic
- Refer to [Google Play Console Help](https://support.google.com/googleplay/android-developer/)
- Refer to [App Store Connect Help](https://developer.apple.com/help/app-store-connect/)
