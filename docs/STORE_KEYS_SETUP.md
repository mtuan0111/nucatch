# Getting the store keys for Fastlane — step by step

This guide gets every value `.env.fastlane` needs so the Fastlane lanes can
upload NuCatch to Google Play and the App Store. Each part has:

- **Before you start** — the account and role you must already have.
- **Steps** — the exact pages, buttons and fields, in order.
- **What you end up with** — the file or values, and where they go.
- **Prompt for Claude in Chrome** — paste it into Claude in Chrome to have it
  walk the website with you. It stops before anything irreversible.

App identifiers used throughout:

| | Value |
| --- | --- |
| Android package | `bomnguyen.nucatch` |
| iOS bundle ID | `bomnguyen.game.nucatch` |
| Apple team ID | `R23LP5MFKD` |
| iOS App Store provisioning profile | `NuCatch_AppStore` |

## What you need, at a glance

| `.env.fastlane` key | What it is | Part |
| --- | --- | --- |
| `SUPPLY_JSON_KEY` | Path to a Google Play **service-account JSON key file** | [1](#part-1--google-play-service-account-json-supply_json_key) |
| `ASC_KEY_ID` | App Store Connect API **Key ID** (10 characters) | [2](#part-2--app-store-connect-api-key-asc_key_id-asc_issuer_id-asc_key_filepath) |
| `ASC_ISSUER_ID` | App Store Connect API **Issuer ID** (a UUID) | [2](#part-2--app-store-connect-api-key-asc_key_id-asc_issuer_id-asc_key_filepath) |
| `ASC_KEY_FILEPATH` | Path to the API key's **`.p8` file** | [2](#part-2--app-store-connect-api-key-asc_key_id-asc_issuer_id-asc_key_filepath) |
| `APPLE_TEAM_ID`, `IOS_PROVISIONING_PROFILE` | Already filled in — only revisit if signing fails | [3](#part-3--ios-signing-only-if-check_env-says-the-profile-is-missing) |
| `FIREBASE_CLI_TOKEN` | Optional — only for the Firebase `distribute` lanes | [4](#part-4--firebase-cli-token-optional-firebase_cli_token) |

Android release signing (`android/key.properties` + `key.jks`) is already set
up and is not part of this guide.

## Safety rules (for you and for Claude in Chrome)

- **Never paste a key file's contents into a chat**, an issue, Slack, or a
  commit. Key IDs, Issuer IDs and service-account emails are fine to share;
  the JSON and `.p8` files are secrets.
- The `.p8` file can be **downloaded only once**. If it's lost, revoke that key
  and create a new one.
- Both key files land in `~/Downloads`. Move them into the repo paths in
  [Part 5](#part-5--put-the-files-in-place-and-check) — those paths are
  git-ignored. Don't leave copies in Downloads.
- Claude in Chrome works in your signed-in browser. Sign in to each site
  yourself first; don't give it passwords or 2FA codes.

---

## Part 1 — Google Play service-account JSON (`SUPPLY_JSON_KEY`)

Google Play's upload API signs in as a *service account* (a robot user from
Google Cloud). You create it in Google Cloud, download its key, then give it
permission for NuCatch in Play Console.

### Before you start

- A Google account that is **Owner or Admin** of the NuCatch developer account
  in [Play Console](https://play.google.com/console).
- The same (or another) Google account with permission to **create service
  accounts and keys** in a Google Cloud project. Any project you control works;
  the NuCatch Firebase project (its ID is `FIREBASE_PROJECT_ID` in `.env`) is a
  natural choice.
- NuCatch must already be published on Play (it is), since `supply` can't create
  a new app.

### Steps — A. Google Cloud: create the service account and key

1. Open <https://console.cloud.google.com/>.
2. In the **project picker** at the top, select the project to use (e.g. the
   NuCatch Firebase project).
3. Enable the API: go to
   <https://console.cloud.google.com/apis/library/androidpublisher.googleapis.com>
   (**APIs & Services → Library → "Google Play Android Developer API"**) and
   click **Enable**. If it says **Manage**, it's already enabled.
4. Go to **IAM & Admin → Service Accounts**
   (<https://console.cloud.google.com/iam-admin/serviceaccounts>).
5. Click **+ Create service account**.
   - **Service account name:** `fastlane-play-upload`
   - **Service account ID:** leave the generated `fastlane-play-upload`.
   - **Description:** `Fastlane uploads for NuCatch (Google Play)`.
   - Click **Create and continue**.
6. **Grant this service account access to project** — leave empty (it needs no
   Cloud roles). Click **Continue**, then **Done**.
7. In the list, **copy the service account's email** — it looks like
   `fastlane-play-upload@<project-id>.iam.gserviceaccount.com`. You need it in
   step B.
8. Click that service account → **Keys** tab → **Add key → Create new key** →
   **Key type: JSON** → **Create**. A file like `<project-id>-1a2b3c4d5e6f.json`
   downloads to `~/Downloads`.
   - If it says key creation is disabled by an organization policy
     (`iam.disableServiceAccountKeyCreation`), an org admin must allow it for
     this project, or use a project outside the organization.

### Steps — B. Play Console: give the service account access to NuCatch

1. Open <https://play.google.com/console> and pick the developer account that
   owns NuCatch.
2. In the left menu (account level, not inside an app) open **Users and
   permissions**.
3. Click **Invite new users**.
4. **Email address:** paste the service-account email from A.7.
5. **Account permissions** tab: leave everything off.
6. **App permissions** tab → **Add app** → select **nuCatch**
   (`bomnguyen.nucatch`) → **Apply**. Turn on:
   - **Releases**
     - Release to production, exclude devices, and use Play App Signing
     - Release apps to testing tracks
     - Manage testing tracks and edit tester lists
   - **Store presence**
     - Edit store listing, pricing & distribution *(needed to upload
       screenshots and "What's new")*
   - Everything else off.
7. Click **Apply**, then **Invite user**, then **Send invitation**. A service
   account doesn't need to accept anything.

> Permission for a new service account can take **up to 24–36 hours** to start
> working. Until then `check_env` may report that the key is valid but lacks
> access — just retry later.

### What you end up with

- File: `~/Downloads/<project-id>-xxxxxxxxxxxx.json`
- Goes to: `android/play-store-service-account.json`
- `.env.fastlane`: `SUPPLY_JSON_KEY=android/play-store-service-account.json`
  (already the default — no edit needed).

### Prompt for Claude in Chrome

```text
Help me create a Google Play upload service account for my Android app.
I'm already signed in to Google Cloud and Play Console in this browser.

Part A — Google Cloud (https://console.cloud.google.com):
1. Ask me which Google Cloud project to use, then select it in the project picker.
2. Open APIs & Services > Library > "Google Play Android Developer API" and
   enable it (skip if it already shows "Manage").
3. Open IAM & Admin > Service Accounts and create a service account:
   name "fastlane-play-upload", description "Fastlane uploads for NuCatch
   (Google Play)". Grant it no project roles.
4. Tell me its full email address (…@….iam.gserviceaccount.com).
5. Open that service account > Keys > Add key > Create new key > JSON.
   STOP and ask me to confirm before clicking Create. After it downloads,
   tell me the downloaded file name. Do NOT open or read the file.

Part B — Play Console (https://play.google.com/console):
6. Open the developer account that owns the app with package
   "bomnguyen.nucatch" (app name nuCatch). Go to Users and permissions >
   Invite new users.
7. Email: the service-account email from step 4.
   Account permissions: none.
   App permissions: add the app nuCatch with only these permissions:
   - Releases: "Release to production, exclude devices, and use Play App
     Signing", "Release apps to testing tracks", "Manage testing tracks and
     edit tester lists"
   - Store presence: "Edit store listing, pricing & distribution"
8. STOP and show me a summary of the invitation before clicking
   "Invite user" / "Send invitation".

If any page looks different from these steps, describe what you see and ask
me before guessing. Never share or display the contents of the JSON key.
```

---

## Part 2 — App Store Connect API key (`ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_FILEPATH`)

Apple's upload and TestFlight APIs sign in with an App Store Connect **team API
key**: a Key ID, the team's Issuer ID, and a private key file (`.p8`).

### Before you start

- An Apple ID with the **Account Holder** or **Admin** role on the team that
  owns NuCatch (team `R23LP5MFKD`) in App Store Connect.
- The first time anyone on the team uses the API, the **Account Holder** must
  click **Request Access** on the API page and accept the terms. After that,
  Admins can create keys.

### Steps

1. Open <https://appstoreconnect.apple.com> and sign in.
2. Click **Users and Access** (top navigation).
3. Open the **Integrations** tab.
4. In the left sidebar, under **Keys**, select **App Store Connect API**, then
   the **Team Keys** tab.
   - If you see **Request Access** instead, the Account Holder must click it and
     accept the terms first.
5. **Copy the Issuer ID** shown above the keys list (format
   `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`). This is `ASC_ISSUER_ID`.
6. Click **Generate API Key** (or the **+** button next to *Active*).
   - **Name:** `fastlane-nucatch`
   - **Access:** **App Manager**
     *(enough to upload builds, manage TestFlight, edit "What's New",
     upload screenshots and submit for review)*
   - Click **Generate**.
7. In the new row, **copy the Key ID** (10 characters, e.g. `AB12CD34EF`). This
   is `ASC_KEY_ID`.
8. Click **Download** in that row. Apple warns this is the only time you can
   download it — confirm. A file named `AuthKey_<KEY_ID>.p8` lands in
   `~/Downloads`.

### What you end up with

- Values: Issuer ID and Key ID (not secret on their own).
- File: `~/Downloads/AuthKey_<KEY_ID>.p8` (secret, one-time download).
- Goes to: `ios/private_keys/AuthKey_<KEY_ID>.p8`
- `.env.fastlane`:
  ```
  ASC_KEY_ID=<KEY_ID>
  ASC_ISSUER_ID=<ISSUER_ID>
  ASC_KEY_FILEPATH=ios/private_keys/AuthKey_<KEY_ID>.p8
  ```

### Prompt for Claude in Chrome

```text
Help me create an App Store Connect API key for Fastlane.
I'm already signed in to https://appstoreconnect.apple.com in this browser.

1. Go to Users and Access > Integrations > App Store Connect API > Team Keys.
   If there's a "Request Access" button instead, stop and tell me (the Account
   Holder has to do that step).
2. Tell me the Issuer ID shown above the key list.
3. Click "Generate API Key" (or the + button). Name: "fastlane-nucatch".
   Access: "App Manager". STOP and ask me to confirm before clicking Generate.
4. Tell me the new key's Key ID (10 characters).
5. STOP and ask me before clicking "Download" — it can only be downloaded
   once. After I confirm, download it and tell me the file name
   (AuthKey_<KEY_ID>.p8). Do NOT open or read the file.

If any page looks different from these steps, describe what you see and ask
me before guessing. Never display the contents of the .p8 key.
```

---

## Part 3 — iOS signing (only if `check_env` says the profile is missing)

`APPLE_TEAM_ID=R23LP5MFKD` and `IOS_PROVISIONING_PROFILE=NuCatch_AppStore` are
already in `.env.fastlane`, and the profile plus an Apple Distribution
certificate are installed on this Mac. Do this part only if
`(cd ios && bundle exec fastlane check_env)` warns that the profile isn't
installed, or a build fails on signing (for example after the profile expires
or on a new Mac).

### Steps — re-download the profile (fastest)

1. Open **Xcode → Settings → Accounts**.
2. Select the Apple ID for team `R23LP5MFKD` → **Download Manual Profiles**.
3. Re-run `check_env`.

### Steps — renew an expired profile on the website

1. Open <https://developer.apple.com/account/resources/profiles/list>
   (**Certificates, IDs & Profiles → Profiles**).
2. Find **NuCatch_AppStore** (type *App Store*, App ID
   `bomnguyen.game.nucatch`).
3. If it shows **Expired** or **Invalid**: click it → **Edit** → make sure a
   current **Apple Distribution** certificate is ticked → **Save** →
   **Download**.
4. Double-click the downloaded `.mobileprovision` to install it, or use Xcode's
   **Download Manual Profiles** as above.
5. Keep the name `NuCatch_AppStore`; if you create a new profile with a
   different name, update `IOS_PROVISIONING_PROFILE` in `.env.fastlane`.

### Prompt for Claude in Chrome

```text
I'm signed in to https://developer.apple.com/account. Open Certificates, IDs &
Profiles > Profiles and find the profile named "NuCatch_AppStore" (App Store
type, App ID bomnguyen.game.nucatch). Tell me its status and expiry date and
which certificate it uses. If it's expired or invalid, open Edit, make sure a
current Apple Distribution certificate is selected, and STOP to ask me before
clicking Save. Don't create, revoke or delete any certificate.
```

---

## Part 4 — Firebase CLI token (optional, `FIREBASE_CLI_TOKEN`)

Only the `distribute` lanes (Firebase App Distribution to testers) use this.
Skip it if you only deploy to the stores.

This is done in the **terminal**, not the website, so Claude in Chrome isn't
needed:

1. Install the CLI if needed: `npm install -g firebase-tools`
2. Run `firebase login:ci`. A browser window opens. Sign in with the Google
   account that has access to the NuCatch Firebase project and click
   **Allow**.
3. The terminal prints a token starting with `1//`. Put it in `.env.fastlane`:
   `FIREBASE_CLI_TOKEN=1//…`

> Google marks `login:ci` tokens as deprecated in favor of service accounts.
> They still work for App Distribution today. If they stop working, ask to
> switch the `distribute` lanes to a service-account key.

---

## Part 5 — Put the files in place and check

From the repo root, after Parts 1 and 2 (replace the file names with yours):

```bash
# Google Play key
mv ~/Downloads/<project-id>-xxxxxxxxxxxx.json android/play-store-service-account.json

# App Store Connect key
mkdir -p ios/private_keys
mv ~/Downloads/AuthKey_<KEY_ID>.p8 ios/private_keys/
```

Edit `.env.fastlane` and fill in `ASC_KEY_ID`, `ASC_ISSUER_ID` and
`ASC_KEY_FILEPATH` (the Play path is already correct). Then confirm the files
are git-ignored and run the checks — they upload nothing:

```bash
git status --short android/play-store-service-account.json ios/private_keys .env.fastlane
# (no output = ignored, as intended)

(cd android && bundle exec fastlane check_env)
(cd ios     && bundle exec fastlane check_env)
```

A green `check_env` on both platforms means the keys are ready. The first real
upload is described in `docs/DEPLOYMENT.md` §5.

## Troubleshooting

| Message | Cause | Fix |
| --- | --- | --- |
| `SUPPLY_JSON_KEY points to …, which doesn't exist` | JSON not moved into place | Part 5 |
| Play: `The caller does not have permission` | Access not granted yet, or propagation delay | Check Part 1 B; wait up to 24–36 h |
| Play: `Google Play Android Developer API has not been used in project …` | API not enabled in that Cloud project | Part 1 A.3 |
| `ASC_KEY_FILEPATH points to …, which doesn't exist` | `.p8` not moved, or the name in `.env.fastlane` doesn't match | Part 5 |
| iOS: `App bomnguyen.game.nucatch not found …` | Key belongs to another team, or access is too low | Recreate the key in team `R23LP5MFKD` with **App Manager** |
| iOS: `401 NOT_AUTHORIZED` | Key revoked, or wrong Key ID / Issuer ID | Re-check values; create a new key if revoked |
| `Provisioning profile 'NuCatch_AppStore' isn't installed` | Profile missing or expired on this Mac | Part 3 |
