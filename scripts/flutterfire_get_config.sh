#!/bin/bash

# Usage: ./flutterfire_get_config.sh [env]
# env: "development" or "production" (default: production)

ENV_FILE=".env"
if [ "$1" == "development" ]; then
  ENV_FILE=".env_dev"
fi

# If the specified env file doesn't exist, fall back to .env
if [ ! -f "$ENV_FILE" ]; then
  echo "Environment file '$ENV_FILE' not found, falling back to .env"
  ENV_FILE=".env"
fi

if [ ! -f "$ENV_FILE" ]; then
  echo "Environment file '$ENV_FILE' not found!"
  exit 1
fi

echo "=== Loading Firebase Configuration from $ENV_FILE ==="

# Load values from the selected .env file
FIREBASE_PROJECT_ID=$(grep '^FIREBASE_PROJECT_ID' "$ENV_FILE" | cut -d '=' -f2 | tr -d ' "')
IOS_BUNDLE_ID=$(grep '^IOS_BUNDLE_ID' "$ENV_FILE" | cut -d '=' -f2 | tr -d ' "')
ANDROID_PACKAGE_NAME=$(grep '^ANDROID_PACKAGE_NAME' "$ENV_FILE" | cut -d '=' -f2 | tr -d ' "')

# Fallback to APP_STORE_BUNDLE_ID and PLAY_STORE_ID if IOS_BUNDLE_ID and ANDROID_PACKAGE_NAME not found
if [ -z "$IOS_BUNDLE_ID" ]; then
  IOS_BUNDLE_ID=$(grep '^APP_STORE_BUNDLE_ID' "$ENV_FILE" | cut -d '=' -f2 | tr -d ' "')
fi

if [ -z "$ANDROID_PACKAGE_NAME" ]; then
  ANDROID_PACKAGE_NAME=$(grep '^PLAY_STORE_ID' "$ENV_FILE" | cut -d '=' -f2 | tr -d ' "')
fi

echo "Firebase Project ID: $FIREBASE_PROJECT_ID"
echo "iOS Bundle ID: $IOS_BUNDLE_ID"
echo "Android Package Name: $ANDROID_PACKAGE_NAME"

if [ -z "$FIREBASE_PROJECT_ID" ]; then
  echo "❌ ERROR: Missing FIREBASE_PROJECT_ID in $ENV_FILE"
  exit 1
fi

if [ -z "$IOS_BUNDLE_ID" ]; then
  echo "⚠️ WARNING: Missing IOS_BUNDLE_ID in $ENV_FILE, skipping iOS"
  PLATFORMS="android"
elif [ -z "$ANDROID_PACKAGE_NAME" ]; then
  echo "⚠️ WARNING: Missing ANDROID_PACKAGE_NAME in $ENV_FILE, skipping Android"
  PLATFORMS="ios"
else
  PLATFORMS="ios,android,web"
fi

echo ""
echo "=== Running FlutterFire Configure ==="
echo "Platforms: $PLATFORMS"
echo ""

flutterfire configure \
  --project="$FIREBASE_PROJECT_ID" \
  ${IOS_BUNDLE_ID:+--ios-bundle-id="$IOS_BUNDLE_ID"} \
  ${ANDROID_PACKAGE_NAME:+--android-package-name="$ANDROID_PACKAGE_NAME"} \
  --platforms=$PLATFORMS \
  --overwrite-firebase-options

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ FlutterFire configuration completed successfully!"
else
  echo ""
  echo "❌ FlutterFire configuration failed!"
  exit 1
fi
