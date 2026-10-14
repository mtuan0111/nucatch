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

  # Whether version string a is strictly higher than b ("2.8.12" > "2.8.11",
  # "94.0" > "93"). False when either isn't a version.
  def self.newer?(a, b)
    a, b = a.to_s, b.to_s
    Gem::Version.correct?(a) && Gem::Version.correct?(b) && Gem::Version.new(a) > Gem::Version.new(b)
  end

  # A true/false lane option (`name:true`), also accepting alternate spellings
  # (e.g. update_screenshot: for update_screenshots:).
  def self.flag?(options, *names)
    names.any? { |n| options[n].to_s == "true" }
  end

  # PNGs per sub-folder of dir (one level), e.g. a locale's screenshot set.
  # Fails if any expected folder is missing or empty — uploading an empty set
  # would leave that locale with no screenshots on the store.
  def self.require_screenshots!(dirs)
    dirs.each do |dir|
      count = Dir.glob(File.join(dir, "*.png")).size
      UI.user_error!("update_screenshots: no screenshots in #{dir.sub("#{ROOT}/", '')} — " \
                     "run tool/screenshots/capture.sh first.") if count.zero?
      UI.message("Screenshots: #{count} in #{dir.sub("#{ROOT}/", '')}")
    end
  end

  # A Play version code from a build number ("07" → 7). Base 10: Integer("09")
  # would read it as octal and fail.
  def self.version_code(build_number)
    Integer(build_number.to_s.split(".").first, 10)
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
  def self.store_release_notes(locales: %w[en-US vi])
    block = latest_changelog_block
    brief = block[/#### Brief for Store's new update:\s*\n(.*?)(?=\n####|\n---|\z)/m, 1]
    bullets = (brief || "").lines.map(&:strip).select { |l| l.start_with?("_ ") }
                           .map { |l| l.sub(/\A_\s*/, "") }
    if bullets.empty?
      note = block[/### Release note:\s*\n(.*?)(?=\n###|\z)/m, 1].to_s
      bullets = note.lines.map(&:strip).select { |l| l.start_with?("- ") }.map { |l| l[2..] }
    end
    vietnamese = /[ăâđêôơưĂÂĐÊÔƠƯàáạảãèéẹẻẽìíịỉĩòóọỏõùúụủũỳýỵỷỹ]/
    english = bullets.reject { |b| b.match?(vietnamese) }
    viet = bullets.select { |b| b.match?(vietnamese) }
    locales.to_h do |locale|
      lines = locale.start_with?("vi") ? viet : (locale.start_with?("en") ? english : [])
      [locale, lines.map { |l| "• #{l}" }.join("\n")]
    end.reject { |_, text| text.empty? }
  end

  # Points the Firebase config at production or development, exactly as the
  # CHANGELOG build commands do, before building. `flutterfire` lives in
  # ~/.pub-cache/bin, which the npm script's own `export PATH` can't add (each
  # npm script runs in its own shell), so it goes on PATH here.
  def self.flutterfire_setup(environment)
    script = environment == "PRODUCTION" ? "flutterfire_setup" : "flutterfire_setup_dev"
    pub_bin = File.expand_path("~/.pub-cache/bin")
    path = [pub_bin, ENV["PATH"]].join(File::PATH_SEPARATOR)
    Dir.chdir(ROOT) do
      already_deleted = `git ls-files --deleted`.split("\n")
      unbundled { Fastlane::Actions.sh({ "PATH" => path }, "npm", "run", script) }
      # The script's `flutter clean` deletes tracked files (macOS Swift package
      # locks). Put back only what this step removed, never your own deletions.
      removed = `git ls-files --deleted`.split("\n") - already_deleted
      Fastlane::Actions.sh("git", "checkout", "--", *removed) unless removed.empty?
    end
  end

  # The app's runtime config file for each environment. `.env` is what gets
  # bundled into the app (pubspec.yaml assets), so a release must be built with
  # the real values in it — the update prompt's store links (ANDROID_PACKAGE_NAME,
  # IOS_APP_ID), the About links and the Gemini key all come from it. The
  # committed-template-style `.env` holds placeholders; the real files are
  # `env` (production) and `env_dev` (development). Override the names with
  # APP_ENV_FILE_PRODUCTION / APP_ENV_FILE_DEVELOPMENT in .env.fastlane.
  def self.app_env_source(environment)
    key = environment == "PRODUCTION" ? "APP_ENV_FILE_PRODUCTION" : "APP_ENV_FILE_DEVELOPMENT"
    default = environment == "PRODUCTION" ? "env" : "env_dev"
    File.expand_path(value(key) || default, ROOT)
  end

  # Runs the block with `.env` replaced by this environment's real app config,
  # then puts the original `.env` back — even if the build fails.
  def self.with_app_env(environment)
    source = app_env_source(environment)
    UI.user_error!("App config #{source} for #{environment} doesn't exist (see APP_ENV_FILE_* in .env.fastlane.example).") unless File.exist?(source)
    contents = File.read(source)
    placeholders = contents.lines.grep(/=\s*your_/).map { |l| l.split("=").first }
    UI.user_error!("#{File.basename(source)} still has placeholder values for: #{placeholders.join(', ')}") unless placeholders.empty?

    target = File.join(ROOT, ".env")
    original = File.exist?(target) ? File.binread(target) : nil
    File.write(target, contents)
    UI.message("Bundling #{File.basename(source)} as .env for this #{environment} build")
    begin
      yield
    ensure
      original ? File.binwrite(target, original) : File.delete(target)
      UI.message("Restored the original .env")
    end
  end

  # Runs `flutter <args>` from the repo root.
  def self.flutter(*args)
    Dir.chdir(ROOT) { unbundled { Fastlane::Actions.sh("flutter", *args) } }
  end

  # Runs the block without `bundle exec`'s environment. Tools Flutter starts
  # (CocoaPods' `pod`, the FlutterFire CLI) otherwise inherit Bundler's
  # Gemfile — which only has fastlane — and fail ("CocoaPods is installed but
  # broken").
  def self.unbundled(&block)
    defined?(Bundler) ? Bundler.with_unbundled_env(&block) : yield
  end
end
