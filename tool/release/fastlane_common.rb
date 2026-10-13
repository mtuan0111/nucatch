# Shared by android/fastlane/Fastfile and ios/fastlane/Fastfile.
#
# Store credentials live in `.env.fastlane` at the repo root (git-ignored;
# template: `.env.fastlane.example`). NOT in `.env`: that file is bundled into
# the app as an asset (pubspec.yaml), so anything in it ships inside the
# APK/IPA. Values already set in the real environment (CI secrets) win.
#
# Versions and store release notes come from the latest CHANGELOG.md block —
# the same commands the release workflow writes (.agents/rules/
# version-release-workflow.mdc) — so a lane run with no arguments uploads the
# version that's being released, not pubspec's older one.
require "dotenv"
require "fastlane_core"

module NucatchRelease
  UI = FastlaneCore::UI
  ROOT = File.expand_path("../..", __dir__)
  ENV_FILE = File.join(ROOT, ".env.fastlane")
  CHANGELOG = File.join(ROOT, "CHANGELOG.md")

  # Loads .env.fastlane without overriding variables that are already set.
  def self.load_env!
    if File.exist?(ENV_FILE)
      Dotenv.load(ENV_FILE)
    else
      UI.important("No .env.fastlane found — using the process environment only. " \
                   "Create it from .env.fastlane.example (docs/DEPLOYMENT.md).")
    end
  end

  def self.value(key)
    v = ENV[key].to_s.strip
    v.empty? ? nil : v
  end

  # ENV[key] as an absolute path; relative values resolve from the repo root.
  def self.path(key)
    v = value(key)
    v && File.expand_path(v, ROOT)
  end

  # Fails with one message naming every key that is unset, so a first-time
  # setup doesn't need a run per missing key.
  def self.require_keys!(*keys)
    missing = keys.flatten.reject { |k| value(k) }
    return if missing.empty?

    UI.user_error!("Missing in .env.fastlane (or the environment): #{missing.join(', ')}. " \
                   "See .env.fastlane.example and docs/DEPLOYMENT.md.")
  end

  # Fails unless ENV[key] names an existing file.
  def self.require_file!(key)
    require_keys!(key)
    file = path(key)
    UI.user_error!("#{key} points to #{file}, which doesn't exist.") unless File.exist?(file)
    file
  end

  # The latest CHANGELOG.md block (everything after the last "## Released on").
  def self.latest_changelog_block
    UI.user_error!("CHANGELOG.md not found at #{CHANGELOG}") unless File.exist?(CHANGELOG)
    text = File.read(CHANGELOG)
    idx = text.rindex(/^## Released on/)
    UI.user_error!("No '## Released on' block in CHANGELOG.md") unless idx
    text[idx..]
  end

  # { build_name:, build_number: } from the latest block's build command for
  # this platform (:android → `flutter build appbundle`, :ios → `flutter build
  # ios`) and environment ("PRODUCTION" / "DEVELOPMENT").
  def self.release_version(platform, environment)
    tool = platform == :android ? "appbundle" : "ios"
    line = latest_changelog_block.lines.find do |l|
      l.include?("flutter build #{tool} ") && l.include?("APP_ENVIRONMENT=#{environment}")
    end
    UI.user_error!("No `flutter build #{tool} … APP_ENVIRONMENT=#{environment}` command in the " \
                   "latest CHANGELOG.md block. Pass build_name: and build_number: instead.") unless line
    {
      build_name: line[/--build-name=(\S+)/, 1],
      build_number: line[/--build-number=(\S+)/, 1],
    }
  end

  # Explicit lane options win; otherwise the CHANGELOG version.
  def self.resolve_version(platform, environment, options)
    from_log = release_version(platform, environment)
    version = {
      build_name: options[:build_name] || from_log[:build_name],
      build_number: options[:build_number] || from_log[:build_number],
    }
    UI.message("Version #{version[:build_name]} (#{version[:build_number]}) — #{environment}")
    version
  end

  # Store "what's new" text per store locale, from the latest block's
  # "Brief for Store's new update" bullets ("_ …"): lines with Vietnamese
  # letters go to "vi", the rest to "en-US". Falls back to "Release note:".
  def self.store_release_notes
    block = latest_changelog_block
    brief = block[/#### Brief for Store's new update:\s*\n(.*?)(?=\n####|\n---|\z)/m, 1]
    bullets = (brief || "").lines.map(&:strip).select { |l| l.start_with?("_ ") }
                           .map { |l| l.sub(/\A_\s*/, "") }
    if bullets.empty?
      note = block[/### Release note:\s*\n(.*?)(?=\n###|\z)/m, 1].to_s
      bullets = note.lines.map(&:strip).select { |l| l.start_with?("- ") }.map { |l| l[2..] }
    end
    vietnamese = /[ăâđêôơưĂÂĐÊÔƠƯàáạảãèéẹẻẽìíịỉĩòóọỏõùúụủũỳýỵỷỹ]/
    notes = {
      "en-US" => bullets.reject { |b| b.match?(vietnamese) },
      "vi" => bullets.select { |b| b.match?(vietnamese) },
    }
    notes.transform_values { |lines| lines.map { |l| "• #{l}" }.join("\n") }
         .reject { |_, text| text.empty? }
  end

  # Points the Firebase config at production or development, exactly as the
  # CHANGELOG build commands do, before building.
  def self.flutterfire_setup(environment)
    script = environment == "PRODUCTION" ? "flutterfire_setup" : "flutterfire_setup_dev"
    Dir.chdir(ROOT) { Fastlane::Actions.sh("npm", "run", script) }
  end

  # Runs `flutter <args>` from the repo root.
  def self.flutter(*args)
    Dir.chdir(ROOT) { Fastlane::Actions.sh("flutter", *args) }
  end
end
