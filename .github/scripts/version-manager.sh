#!/bin/bash

# Version Manager Script for NuCatch
# Usage: ./version-manager.sh [platform] [environment] [action]
# Example: ./version-manager.sh android dev bump-patch

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../config/version-config.json"
WHATSNEW_DIR_ANDROID="$SCRIPT_DIR/../../distribution/whatsnew"
WHATSNEW_DIR_IOS="$SCRIPT_DIR/../../distribution/whatsnew-ios"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    print_error "jq is required but not installed. Install with: brew install jq"
    exit 1
fi

# Parse arguments
PLATFORM=$1  # android or ios
ENVIRONMENT=$2  # dev or prod
ACTION=$3  # get, bump-major, bump-minor, bump-patch, set

# Validate arguments
if [[ ! "$PLATFORM" =~ ^(android|ios)$ ]]; then
    print_error "Invalid platform. Use 'android' or 'ios'"
    exit 1
fi

if [[ ! "$ENVIRONMENT" =~ ^(dev|prod)$ ]]; then
    print_error "Invalid environment. Use 'dev' or 'prod'"
    exit 1
fi

# Get current version
get_version() {
    if [ "$PLATFORM" = "android" ]; then
        VERSION_NAME=$(jq -r ".android.$ENVIRONMENT.versionName" "$CONFIG_FILE")
        VERSION_CODE=$(jq -r ".android.$ENVIRONMENT.versionCode" "$CONFIG_FILE")
        echo "versionName: $VERSION_NAME"
        echo "versionCode: $VERSION_CODE"
    else
        VERSION_NAME=$(jq -r ".ios.$ENVIRONMENT.versionName" "$CONFIG_FILE")
        BUILD_NUMBER=$(jq -r ".ios.$ENVIRONMENT.buildNumber" "$CONFIG_FILE")
        echo "versionName: $VERSION_NAME"
        echo "buildNumber: $BUILD_NUMBER"
    fi
}

# Bump version
bump_version() {
    local BUMP_TYPE=$1
    
    if [ "$PLATFORM" = "android" ]; then
        CURRENT_VERSION=$(jq -r ".android.$ENVIRONMENT.versionName" "$CONFIG_FILE")
        CURRENT_CODE=$(jq -r ".android.$ENVIRONMENT.versionCode" "$CONFIG_FILE")
    else
        CURRENT_VERSION=$(jq -r ".ios.$ENVIRONMENT.versionName" "$CONFIG_FILE")
        CURRENT_BUILD=$(jq -r ".ios.$ENVIRONMENT.buildNumber" "$CONFIG_FILE")
    fi
    
    # Split version into parts (e.g., 2.0.0)
    IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"
    MAJOR=${VERSION_PARTS[0]}
    MINOR=${VERSION_PARTS[1]}
    PATCH=${VERSION_PARTS[2]}
    
    case $BUMP_TYPE in
        bump-major)
            MAJOR=$((MAJOR + 1))
            MINOR=0
            PATCH=0
            ;;
        bump-minor)
            MINOR=$((MINOR + 1))
            PATCH=0
            ;;
        bump-patch)
            PATCH=$((PATCH + 1))
            ;;
        *)
            print_error "Invalid bump type. Use: bump-major, bump-minor, or bump-patch"
            exit 1
            ;;
    esac
    
    NEW_VERSION="$MAJOR.$MINOR.$PATCH"
    
    if [ "$PLATFORM" = "android" ]; then
        NEW_CODE=$((CURRENT_CODE + 1))
        jq ".android.$ENVIRONMENT.versionName = \"$NEW_VERSION\" | .android.$ENVIRONMENT.versionCode = $NEW_CODE" "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
        print_success "Updated Android $ENVIRONMENT: $CURRENT_VERSION ($CURRENT_CODE) → $NEW_VERSION ($NEW_CODE)"
    else
        # For iOS, increment build number
        IFS='.' read -ra BUILD_PARTS <<< "$CURRENT_BUILD"
        if [ ${#BUILD_PARTS[@]} -eq 1 ]; then
            NEW_BUILD=$((BUILD_PARTS[0] + 1))
        else
            MAIN_BUILD=${BUILD_PARTS[0]}
            SUB_BUILD=${BUILD_PARTS[1]}
            NEW_BUILD="$MAIN_BUILD.$((SUB_BUILD + 1))"
        fi
        jq ".ios.$ENVIRONMENT.versionName = \"$NEW_VERSION\" | .ios.$ENVIRONMENT.buildNumber = \"$NEW_BUILD\"" "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
        print_success "Updated iOS $ENVIRONMENT: $CURRENT_VERSION ($CURRENT_BUILD) → $NEW_VERSION ($NEW_BUILD)"
    fi
    
    # Update metadata
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    jq ".metadata.lastUpdated = \"$TIMESTAMP\"" "$CONFIG_FILE.tmp" > "$CONFIG_FILE"
    rm "$CONFIG_FILE.tmp"
}

# Set custom version
set_version() {
    local NEW_VERSION=$1
    local NEW_BUILD=$2
    
    if [ -z "$NEW_VERSION" ]; then
        print_error "Version name is required"
        exit 1
    fi
    
    if [ "$PLATFORM" = "android" ]; then
        if [ -z "$NEW_BUILD" ]; then
            print_error "Version code is required for Android"
            exit 1
        fi
        jq ".android.$ENVIRONMENT.versionName = \"$NEW_VERSION\" | .android.$ENVIRONMENT.versionCode = $NEW_BUILD" "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
        print_success "Set Android $ENVIRONMENT to: $NEW_VERSION ($NEW_BUILD)"
    else
        if [ -z "$NEW_BUILD" ]; then
            print_error "Build number is required for iOS"
            exit 1
        fi
        jq ".ios.$ENVIRONMENT.versionName = \"$NEW_VERSION\" | .ios.$ENVIRONMENT.buildNumber = \"$NEW_BUILD\"" "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
        print_success "Set iOS $ENVIRONMENT to: $NEW_VERSION ($NEW_BUILD)"
    fi
    
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    jq ".metadata.lastUpdated = \"$TIMESTAMP\"" "$CONFIG_FILE.tmp" > "$CONFIG_FILE"
    rm "$CONFIG_FILE.tmp"
}

# Update release notes
update_release_notes() {
    local NOTES=$1
    local LANG=${2:-"en-US"}  # Default to en-US if no language specified
    
    if [ -z "$NOTES" ]; then
        print_error "Release notes are required"
        exit 1
    fi
    
    jq ".$PLATFORM.$ENVIRONMENT.releaseNotes[\"$LANG\"] = \"$NOTES\"" "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
    mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    print_success "Updated release notes for $PLATFORM $ENVIRONMENT ($LANG)"
    
    # Generate what's new files for all languages
    generate_whatsnew_files
}

# Generate what's new files for Google Play/TestFlight
generate_whatsnew_files() {
    print_info "Generating what's new files for all languages..."
    
    if [ "$PLATFORM" = "android" ]; then
        mkdir -p "$WHATSNEW_DIR_ANDROID"
        WHATSNEW_DIR="$WHATSNEW_DIR_ANDROID"
    else
        mkdir -p "$WHATSNEW_DIR_IOS"
        WHATSNEW_DIR="$WHATSNEW_DIR_IOS"
    fi
    
    # Get all language keys from releaseNotes
    LANGUAGES=$(jq -r ".$PLATFORM.$ENVIRONMENT.releaseNotes | keys[]" "$CONFIG_FILE")
    
    # Generate file for each language
    for LANG in $LANGUAGES; do
        NOTES=$(jq -r ".$PLATFORM.$ENVIRONMENT.releaseNotes[\"$LANG\"]" "$CONFIG_FILE")
        echo "$NOTES" > "$WHATSNEW_DIR/$LANG.txt"
        print_success "Generated $LANG.txt"
    done
    
    print_success "Generated what's new files for languages: $LANGUAGES"
}

# Export version as GitHub Actions environment variables
export_for_github() {
    if [ "$PLATFORM" = "android" ]; then
        VERSION_NAME=$(jq -r ".android.$ENVIRONMENT.versionName" "$CONFIG_FILE")
        VERSION_CODE=$(jq -r ".android.$ENVIRONMENT.versionCode" "$CONFIG_FILE")
        echo "ANDROID_VERSION_NAME=$VERSION_NAME"
        echo "ANDROID_VERSION_CODE=$VERSION_CODE"
    else
        VERSION_NAME=$(jq -r ".ios.$ENVIRONMENT.versionName" "$CONFIG_FILE")
        BUILD_NUMBER=$(jq -r ".ios.$ENVIRONMENT.buildNumber" "$CONFIG_FILE")
        echo "IOS_VERSION_NAME=$VERSION_NAME"
        echo "IOS_BUILD_NUMBER=$BUILD_NUMBER"
    fi
}

# Main logic
case $ACTION in
    get)
        print_info "Current version for $PLATFORM ($ENVIRONMENT):"
        get_version
        ;;
    bump-major|bump-minor|bump-patch)
        bump_version "$ACTION"
        ;;
    set)
        set_version "$4" "$5"
        ;;
    update-notes)
        update_release_notes "$4" "$5"
        ;;
    export)
        export_for_github
        ;;
    *)
        echo "Usage: $0 [platform] [environment] [action] [args...]"
        echo ""
        echo "Platforms: android, ios"
        echo "Environments: dev, prod"
        echo "Actions:"
        echo "  get                                - Get current version"
        echo "  bump-major                         - Bump major version (X.0.0)"
        echo "  bump-minor                         - Bump minor version (x.X.0)"
        echo "  bump-patch                         - Bump patch version (x.x.X)"
        echo "  set <version> <code/build>         - Set custom version"
        echo "  update-notes <notes> [language]    - Update release notes (default: en-US)"
        echo "  export                             - Export for GitHub Actions"
        echo ""
        echo "Examples:"
        echo "  $0 android dev get"
        echo "  $0 android dev bump-patch"
        echo "  $0 ios prod set 2.1.0 35"
        echo "  $0 android dev update-notes 'Bug fixes and improvements'"
        echo "  $0 android dev update-notes 'Sửa lỗi và cải thiện hiệu suất' vi-VN"
        exit 1
        ;;
esac
