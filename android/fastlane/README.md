fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android check_env

```sh
[bundle exec] fastlane android check_env
```

Check that everything a Play upload needs is in place: .env.fastlane

keys, the service-account JSON (validated against Google), and release

signing. Uploads nothing. Usage: fastlane android check_env

### android distribute

```sh
[bundle exec] fastlane android distribute
```

Deploy a new build to Firebase App Distribution

### android upload_screenshots

```sh
[bundle exec] fastlane android upload_screenshots
```

Upload store screenshots ONLY to Google Play.

Media only — no APK/AAB, no metadata, no changelogs. Frames come from

android/fastlane/metadata/android/<locale>/images/{phone,tenInch}Screenshots/

(run tool/screenshots/capture.sh first). The app must already exist on

Play with an initial release. See tool/screenshots/README.md.

### android deploy_staging

```sh
[bundle exec] fastlane android deploy_staging
```

Staging: build a release AAB (Firebase dev config) and upload to the

Google Play INTERNAL track.

Usage: fastlane android deploy_staging [build_name:2.8.12.0 build_number:95]

### android deploy_production

```sh
[bundle exec] fastlane android deploy_production
```

Production: build a release AAB (Firebase production config) and upload

to the Google Play PRODUCTION track.

Usage: fastlane android deploy_production [build_name:2.8.12 build_number:95]

Add release_status:draft to upload without rolling out.

### android deploy

```sh
[bundle exec] fastlane android deploy
```

Alias for deploy_production (fastlane android deploy)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
