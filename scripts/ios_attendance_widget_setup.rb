#!/usr/bin/env ruby
# frozen_string_literal: true

# ios_attendance_widget_setup.rb
# ------------------------------
# Programmatically wires the AttendanceWidget Live Activity extension
# into ios/Runner.xcodeproj so we never need to open Xcode (the dev
# machine is Windows; only Codemagic's macOS runners ever touch this
# project).
#
# Run in CI on every iOS build. The script is fully idempotent:
#   - if the target already exists, we re-verify settings and exit 0
#   - if any wiring step has been done before, it is skipped
#
# Manual local invocation (macOS only, requires xcodeproj gem):
#   gem install xcodeproj
#   ruby scripts/ios_attendance_widget_setup.rb
#
# Codemagic invocation: see codemagic.yaml step
# "Wire AttendanceWidget extension target into Xcode project".
#
# What the script does:
#   1. Adds a Widget Extension PBXNativeTarget named `AttendanceWidget`.
#   2. Adds the four source files under ios/AttendanceWidget/ (.swift,
#      Info.plist, .entitlements) to the new target.
#   3. Sets bundle id, deployment target, signing team, entitlements
#      file, swift version, info.plist path, marketing version, and
#      build number for both Debug + Release configurations.
#   4. Adds an "Embed App Extensions" copy-files phase to the Runner
#      target so the .appex is bundled inside the host app.
#   5. Creates / updates ios/Runner/Runner.entitlements with the
#      App Groups capability and aps-environment for Push
#      Notifications (required by ActivityKit), and points the
#      Runner target's CODE_SIGN_ENTITLEMENTS at it.
#   6. Sets DEVELOPMENT_TEAM on Runner if it isn't already set
#      (no-op when the value already matches).

require 'xcodeproj'
require 'fileutils'

# Escape hatch: set ENABLE_LIVE_ACTIVITY=false in Codemagic env vars to
# ship an iOS build *without* the AttendanceWidget extension target.
# Useful when debugging Codemagic signing issues â€” the in-app timer and
# Android FGS still work without the Lock-Screen Live Activity. Default
# is to install the target.
if ENV['ENABLE_LIVE_ACTIVITY'] == 'false'
  warn '[ios_attendance_widget_setup] ENABLE_LIVE_ACTIVITY=false â€” skipping all setup'
  exit 0
end

PROJECT_PATH       = File.expand_path('../ios/Runner.xcodeproj', __dir__)
APP_BUNDLE_ID      = 'com.technology92.employee'
WIDGET_BUNDLE_ID   = 'com.technology92.employee.AttendanceWidget'
WIDGET_NAME        = 'AttendanceWidget'
DEV_TEAM           = '7L3U2W8Z5F'
APP_GROUP_ID       = 'group.com.technology92.employee.liveactivities'
DEPLOYMENT_TARGET  = '16.1' # ActivityKit minimum
SWIFT_VERSION      = '5.0'
WIDGET_DIR_REL     = 'AttendanceWidget' # relative to ios/
RUNNER_DIR_REL     = 'Runner'

WIDGET_SOURCES = %w[
  AttendanceWidgetBundle.swift
  AttendanceLiveActivity.swift
].freeze

# Folder-style resources that need to land in the widget target's
# Copy Bundle Resources phase (NOT the source-build phase). Currently
# just the asset catalog that holds the white app logo used by the
# Lock Screen / Dynamic Island views â€” Flutter's `assets/images/...`
# tree is unreachable from a Swift extension, so the widget ships its
# own copy under `ios/AttendanceWidget/Assets.xcassets/`.
WIDGET_RESOURCES = %w[
  Assets.xcassets
].freeze

def log(msg)
  puts "[ios_attendance_widget_setup] #{msg}"
end

def abort_with(msg)
  warn "[ios_attendance_widget_setup] ERROR: #{msg}"
  exit 1
end

# Single source of truth for the AttendanceWidget target's build
# settings, applied to every configuration (Debug, Profile, Release)
# both on first creation and on every idempotent re-run.
#
# CODE_SIGN_IDENTITY is the critical bit: when xcodeproj-gem creates a
# new :application_extension target, it seeds Release with
# `CODE_SIGN_IDENTITY = "iPhone Developer"`. Codemagic only ships an
# Apple Distribution cert for App Store builds, so xcodebuild would
# fail the archive with "No valid code signing certificates were
# found" *even though* `xcode-project use-profiles` had assigned the
# correct distribution profile. Pinning the identity to "Apple
# Distribution" (and the SDK-scoped variant Xcode actually evaluates)
# tells xcodebuild to use the cert that's already in the keychain.
def apply_widget_build_settings(cfg)
  bs = cfg.build_settings
  bs['PRODUCT_BUNDLE_IDENTIFIER']             = WIDGET_BUNDLE_ID
  bs['PRODUCT_NAME']                          = '$(TARGET_NAME)'
  bs['INFOPLIST_FILE']                        = "#{WIDGET_DIR_REL}/Info.plist"
  bs['CODE_SIGN_ENTITLEMENTS']                = "#{WIDGET_DIR_REL}/AttendanceWidget.entitlements"
  bs['CODE_SIGN_STYLE']                       = 'Manual'
  bs['CODE_SIGN_IDENTITY']                    = 'Apple Distribution'
  bs['CODE_SIGN_IDENTITY[sdk=iphoneos*]']     = 'Apple Distribution'
  bs['DEVELOPMENT_TEAM']                      = DEV_TEAM
  bs['IPHONEOS_DEPLOYMENT_TARGET']            = DEPLOYMENT_TARGET
  bs['SWIFT_VERSION']                         = SWIFT_VERSION
  bs['SKIP_INSTALL']                          = 'NO' # ship inside host app
  bs['TARGETED_DEVICE_FAMILY']                = '1' # iPhone-only, matches Runner
  bs['LD_RUNPATH_SEARCH_PATHS']               = '$(inherited) @executable_path/Frameworks @executable_path/../../Frameworks'
  bs['MARKETING_VERSION']                     = '$(MARKETING_VERSION)'
  bs['CURRENT_PROJECT_VERSION']               = '$(CURRENT_PROJECT_VERSION)'
  bs['ENABLE_BITCODE']                        = 'NO'
  # IMPORTANT: do NOT set ASSETCATALOG_COMPILER_APPICON_NAME on the
  # widget. Setting it to '' does NOT disable the lookup â€” Xcode treats
  # an empty value as the default "AppIcon" and `actool` then aborts the
  # archive with "None of the input catalogs contained a matching ...
  # icon set ... named 'AppIcon'" because widget extensions don't (and
  # shouldn't) ship their own AppIcon â€” they inherit the host app's.
  # We DELETE the key so the setting is unset for this target, which
  # causes `actool` to skip the icon-set lookup entirely.
  bs.delete('ASSETCATALOG_COMPILER_APPICON_NAME')
  bs['CLANG_ENABLE_MODULES']                  = 'YES'
  bs['INFOPLIST_KEY_NSHumanReadableCopyright'] = ''
  bs['INFOPLIST_KEY_CFBundleDisplayName']     = 'Attendance Widget'
  # Avoid the autogenerated Info.plist clash â€” we ship our own.
  bs['GENERATE_INFOPLIST_FILE']               = 'NO'
end

abort_with("project not found at #{PROJECT_PATH}") unless File.directory?(PROJECT_PATH)

project = Xcodeproj::Project.open(PROJECT_PATH)
runner_target = project.targets.find { |t| t.name == 'Runner' } ||
                abort_with('Runner target not found in project')

# ---------------------------------------------------------------------
# 1. Ensure / create Runner.entitlements with App Groups + APS env
# ---------------------------------------------------------------------
runner_entitlements_path = File.join(File.dirname(PROJECT_PATH), RUNNER_DIR_REL, 'Runner.entitlements')

def write_runner_entitlements(path)
  # The Runner target needs TWO capabilities baked into its entitlements:
  #
  #   1. `com.apple.security.application-groups` â€” required so the
  #      Runner host app and the AttendanceWidget extension can read /
  #      write the same `UserDefaults(suiteName:)` for the Live Activity
  #      timer hand-off.
  #
  #   2. `com.apple.developer.applesignin` â€” required by App Review
  #      Guideline 4.8 (the app offers Google Sign-In, so it must also
  #      offer Sign In with Apple). Without this entitlement key in the
  #      *signed binary*, iOS rejects every `getAppleIDCredential` call
  #      with `ASAuthorizationErrorUnknown` (NSError 1000) BEFORE the
  #      sheet ever appears, even when the App ID + provisioning
  #      profile both grant the capability. We learned this the hard
  #      way: every Codemagic build between Live Activities being added
  #      and 2026-05-15 was being silently stripped of this entitlement
  #      because this script overwrote the file with App Groups only.
  #
  # We deliberately do NOT include `aps-environment` here, even though
  # the live_activities plugin's README suggests adding the Push
  # Notifications capability. Reasons:
  #
  #   * The widget timer is rendered by SwiftUI's `Text(timerInterval:)`
  #     which ticks natively against a wall-clock range â€” no APNs needed
  #     to keep the Lock-Screen counter moving.
  #   * Setting `aps-environment` to `development` forces Xcode to
  #     demand a *development* certificate during archiving (this
  #     broke the first Codemagic build). Setting it to `production`
  #     would work for App Store builds but would require enabling the
  #     Push Notifications capability on the Apple App ID first, adding
  #     a second mandatory browser-only setup step on the developer
  #     portal that we don't need.
  #
  # If we ever decide to push-update Live Activities from a server,
  # add `aps-environment = production` here AND enable Push
  # Notifications on the `com.technology92.employee` App ID at
  # https://developer.apple.com/account/resources/identifiers
  content = <<~PLIST
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>com.apple.developer.applesignin</key>
        <array>
            <string>Default</string>
        </array>
        <key>com.apple.security.application-groups</key>
        <array>
            <string>#{APP_GROUP_ID}</string>
        </array>
    </dict>
    </plist>
  PLIST
  FileUtils.mkdir_p(File.dirname(path))
  # Idempotency: only skip the write when the file ALREADY contains BOTH
  # required capability keys AND has NOT regressed to including
  # `aps-environment` (see comment above re: why we strip that out).
  # Missing either key forces a rewrite â€” this is what protects us from
  # the Sign In with Apple regression that shipped with build 25.
  needs_rewrite =
    !File.exist?(path) ||
    !File.read(path).include?('com.apple.developer.applesignin') ||
    !File.read(path).include?(APP_GROUP_ID) ||
    File.read(path).include?('aps-environment')
  if needs_rewrite
    File.write(path, content)
    log("Runner.entitlements written")
  else
    log("Runner.entitlements already correct - skipping write")
  end
end

write_runner_entitlements(runner_entitlements_path)

# Make sure the entitlements file is part of the project tree (so Xcode
# can resolve $(SRCROOT)/Runner/Runner.entitlements references).
runner_group = project.main_group['Runner'] || project.main_group
unless runner_group.files.any? { |f| f.path == 'Runner.entitlements' || f.display_name == 'Runner.entitlements' }
  runner_group.new_reference('Runner.entitlements')
  log('Added Runner.entitlements to project tree')
end

# Wire CODE_SIGN_ENTITLEMENTS on Runner build configs.
runner_target.build_configurations.each do |cfg|
  if cfg.build_settings['CODE_SIGN_ENTITLEMENTS'] != 'Runner/Runner.entitlements'
    cfg.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'Runner/Runner.entitlements'
    log("Set CODE_SIGN_ENTITLEMENTS on Runner.#{cfg.name}")
  end
  if cfg.build_settings['DEVELOPMENT_TEAM'] != DEV_TEAM
    cfg.build_settings['DEVELOPMENT_TEAM'] = DEV_TEAM
    log("Set DEVELOPMENT_TEAM on Runner.#{cfg.name}")
  end
end

# ---------------------------------------------------------------------
# 2. Create the AttendanceWidget target if missing
# ---------------------------------------------------------------------
widget_target = project.targets.find { |t| t.name == WIDGET_NAME }

if widget_target.nil?
  log("Creating new AttendanceWidget extension target")

  # `new_target` doesn't have a built-in :app_extension shortcut in
  # all xcodeproj versions, so we create + adjust manually.
  widget_target = project.new_target(
    :application_extension,
    WIDGET_NAME,
    :ios,
    DEPLOYMENT_TARGET
  )

  # Mark as a Widget Extension (required for SwiftUI WidgetBundle).
  widget_target.build_configurations.each do |cfg|
    apply_widget_build_settings(cfg)
  end
else
  log("AttendanceWidget target already exists - re-verifying settings")
  widget_target.build_configurations.each do |cfg|
    apply_widget_build_settings(cfg)
  end
end

# Belt-and-braces: explicitly pin the productType + product reference
# fileType so the pbxproj always serialises the keys Xcode 16's PIF
# loader requires. Without this, `xcodebuild` archive aborts with:
#   "Could not compute dependency graph: unable to load transferred
#    PIF: Required key 'productTypeIdentifier' is missing in
#    StandardTarget dictionary"
# even though `new_target(:application_extension, ...)` is supposed to
# set these. xcodeproj versions before 1.26.0 silently omit the field;
# we install >= 1.27 in CI but a duplicate explicit assignment keeps
# the script safe across older local Ruby installs as well.
widget_target.product_type = 'com.apple.product-type.app-extension'
if widget_target.product_reference
  widget_target.product_reference.explicit_file_type = 'wrapper.app-extension'
  widget_target.product_reference.include_in_index = '0'
end

# ---------------------------------------------------------------------
# 3. Add source files to the widget target (idempotent)
# ---------------------------------------------------------------------
widget_group = project.main_group[WIDGET_DIR_REL] ||
               project.main_group.new_group(WIDGET_DIR_REL, WIDGET_DIR_REL)

# Make sure non-source resources are referenced too (so they land in
# the project navigator and Xcode picks them up).
%w[Info.plist AttendanceWidget.entitlements README.md].each do |fname|
  unless widget_group.files.any? { |f| f.display_name == fname }
    widget_group.new_reference(fname)
    log("Added #{fname} to project tree")
  end
end

WIDGET_SOURCES.each do |src|
  file_ref = widget_group.files.find { |f| f.display_name == src }
  if file_ref.nil?
    file_ref = widget_group.new_reference(src)
    log("Added #{src} to project tree")
  end

  already_built = widget_target.source_build_phase.files_references.any? { |r| r.display_name == src }
  unless already_built
    widget_target.add_file_references([file_ref])
    log("Added #{src} to AttendanceWidget compile sources")
  end
end

# ---------------------------------------------------------------------
# 3a. Add bundle resources (asset catalogs etc.) to the widget target
# ---------------------------------------------------------------------
# Asset catalogs (`*.xcassets`) need TWO things to actually compile into
# the .appex:
#   a. A folder reference (or PBXFileReference with file_type
#      "folder.assetcatalog") in the project tree.
#   b. Membership in the target's `Resources` (Copy Bundle Resources)
#      build phase â€” NOT the source-build phase used by .swift files.
# Without (b) the catalog is visible in the navigator but `actool` is
# never invoked, and `Image("AppLogo")` resolves to nil at runtime â€”
# the SF-symbol fallback shows nothing because we're now passing a
# named-asset string instead of a system name.
WIDGET_RESOURCES.each do |res|
  ref = widget_group.files.find { |f| f.display_name == res }
  if ref.nil?
    # `xcodeproj` recognises the `.xcassets` extension and creates a
    # PBXFileReference with last_known_file_type = `folder.assetcatalog`,
    # which is what Xcode itself emits when you drag the catalog into
    # the project. No special flag needed.
    ref = widget_group.new_reference(res)
    log("Added #{res} to project tree")
  end

  already_in_phase = widget_target.resources_build_phase.files_references.any? do |r|
    r.display_name == res
  end
  unless already_in_phase
    widget_target.resources_build_phase.add_file_reference(ref)
    log("Added #{res} to AttendanceWidget bundle resources")
  end
end

# ---------------------------------------------------------------------
# 4. Embed the .appex inside the Runner host app
# ---------------------------------------------------------------------
embed_phase = runner_target.copy_files_build_phases.find { |p| p.name == 'Embed App Extensions' }

if embed_phase.nil?
  embed_phase = runner_target.new_copy_files_build_phase('Embed App Extensions')
  # Subfolder spec 13 = PlugIns. Apple uses this slot for app
  # extensions (AppName.app/PlugIns/Foo.appex). The xcodeproj gem
  # accepts either the symbol :plug_ins (newer versions) or the raw
  # numeric string '13' â€” the string is the format the .pbxproj
  # actually stores so it's the most portable.
  embed_phase.dst_subfolder_spec = '13'
  log("Created 'Embed App Extensions' build phase on Runner")
end

unless embed_phase.files_references.any? { |r| r == widget_target.product_reference }
  build_file = embed_phase.add_file_reference(widget_target.product_reference)
  # Codesign on copy is required for app extensions.
  build_file.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy', 'CodeSignOnCopy'] }
  log("Embedded AttendanceWidget.appex into Runner")
end

# Make Runner depend on AttendanceWidget so the extension is built first.
unless runner_target.dependencies.any? { |d| d.target == widget_target }
  runner_target.add_dependency(widget_target)
  log("Added Runner -> AttendanceWidget target dependency")
end

# ---------------------------------------------------------------------
# 5. Save
# ---------------------------------------------------------------------
project.save
log('Project saved successfully')

