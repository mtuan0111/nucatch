fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios check_release

```sh
[bundle exec] fastlane ios check_release
```

Check, before building, that App Store Connect can accept a version:

higher than the live one, a new build number, and (for production) no

other version in review. Builds and uploads nothing.

Usage: fastlane ios check_release [build_name:2.8.13 build_number:95] [environment:DEVELOPMENT]

### ios check_env

```sh
[bundle exec] fastlane ios check_env
```

Check that everything an App Store upload needs is in place:

.env.fastlane keys, the API key (checked against App Store Connect),

and the signing profile. Uploads nothing. Usage: fastlane ios check_env

### ios distribute

```sh
[bundle exec] fastlane ios distribute
```

Deploy a new build to Firebase App Distribution

### ios upload_screenshots

```sh
[bundle exec] fastlane ios upload_screenshots
```

Upload store screenshots ONLY to App Store Connect.

Media only — no binary, no metadata, no submit for review. Frames come

from ios/fastlane/screenshots/<locale>/ (run tool/screenshots/capture.sh

first). See tool/screenshots/README.md.

### ios deploy_staging

```sh
[bundle exec] fastlane ios deploy_staging
```

Staging: build a release IPA (Firebase dev config) and upload to

TestFlight for internal testers, with the CHANGELOG notes as 'What to Test'.

Usage: fastlane ios deploy_staging [build_name:2.8.12 build_number:94.0]

### ios deploy_production

```sh
[bundle exec] fastlane ios deploy_production
```

Production: build a release IPA (Firebase production config), upload it

to App Store Connect, set the version's 'What's New' (en-US, vi) from the

CHANGELOG, then submit it for App Review (waits for Apple to finish

processing the build). submit:false uploads without submitting.

update_screenshots:true also replaces the App Store screenshots from

ios/fastlane/screenshots/<locale> (tool/screenshots/capture.sh); default false.

Already uploaded (that exact build, e.g. from TestFlight)? It isn't rebuilt:

it's promoted — What's New set, build attached, submitted (submit:true).

Already waiting for / in review: nothing to deploy (success).

Usage: fastlane ios deploy_production [build_name:2.8.12 build_number:94] [submit:false] [update_screenshots:true] [auto_release:true]

### ios submit_review

```sh
[bundle exec] fastlane ios submit_review
```

Submit an already-uploaded build for App Review — no rebuild. Waits for

Apple to finish processing the build, attaches it to the version and

submits. Export compliance is answered by Info.plist

(ITSAppUsesNonExemptEncryption = false). After approval the release is

manual unless auto_release:true. Version defaults to the CHANGELOG.

An "Add for Review" draft holding this version is submitted as is; a

version already waiting for / in review is reported, not resubmitted.

Usage: fastlane ios submit_review [build_name:2.8.12 build_number:94] [auto_release:true]

### ios deploy

```sh
[bundle exec] fastlane ios deploy
```

Alias for deploy_production (fastlane ios deploy)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
