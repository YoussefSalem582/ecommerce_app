#!/usr/bin/env bash
# Renames old v1.x.x GitHub tags/releases to match the v0.x.x versioning scheme.
#
# Run after:  gh auth login
#
# What it does:
#   1. Deletes old GitHub releases (v1.0.0 â€“ v1.3.0) and their remote tags
#   2. Creates new local tags at the same commits
#   3. Pushes new tags to origin
#   4. Creates new GitHub releases with full notes
#   5. Ensures v0.4.1 release exists with notes

set -e

REPO="technology92/tech_92_mobile_app"

# â”€â”€ 1. Delete old releases & remote tags â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

echo "Deleting old GitHub releases..."
gh release delete v1.0.0 --repo "$REPO" --yes 2>/dev/null || echo "  v1.0.0 release not found, skipping"
gh release delete v1.1.0 --repo "$REPO" --yes 2>/dev/null || echo "  v1.1.0 release not found, skipping"
gh release delete v1.2.0 --repo "$REPO" --yes 2>/dev/null || echo "  v1.2.0 release not found, skipping"
gh release delete v1.3.0 --repo "$REPO" --yes 2>/dev/null || echo "  v1.3.0 release not found, skipping"

echo "Deleting old remote tags..."
git push origin --delete v1.0.0 2>/dev/null || echo "  remote v1.0.0 tag not found, skipping"
git push origin --delete v1.1.0 2>/dev/null || echo "  remote v1.1.0 tag not found, skipping"
git push origin --delete v1.2.0 2>/dev/null || echo "  remote v1.2.0 tag not found, skipping"
git push origin --delete v1.3.0 2>/dev/null || echo "  remote v1.3.0 tag not found, skipping"

echo "Deleting old local tags..."
git tag -d v1.0.0 2>/dev/null || true
git tag -d v1.1.0 2>/dev/null || true
git tag -d v1.2.0 2>/dev/null || true
git tag -d v1.3.0 2>/dev/null || true

# â”€â”€ 2. Create new local tags at the same commits â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

echo "Creating new local tags..."
git tag -a v0.1.0 7b95c7c -m "Release v0.1.0 â€” Initial Release"
git tag -a v0.2.0 f28baed -m "Release v0.2.0 â€” KPI, Attendance & Settings"
git tag -a v0.3.0 3c21719 -m "Release v0.3.0 â€” Locale-Aware Profile, Multi-Skill Add & UX Improvements"
git tag -a v0.4.0 f03d3d7 -m "Release v0.4.0 â€” Profile UX Overhaul, Essential Data Wizard & AppToast"

echo "Pushing new tags to origin..."
git push origin v0.1.0 v0.2.0 v0.3.0 v0.4.0

# â”€â”€ 3. Create new GitHub releases â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

echo "Creating release v0.1.0..."
gh release create v0.1.0 --verify-tag --repo "$REPO" \
  --title "Release v0.1.0 â€” Initial Release" \
  --notes "## v0.1.0 â€” February 17, 2026

### Welcome
- Sign up and log in with email or Google Sign-In
- Create and view your profile
- Upload your profile picture
- Switch between English and Arabic
- Choose light or dark theme
- Clean Architecture + BLoC foundation"

echo "Creating release v0.2.0..."
gh release create v0.2.0 --verify-tag --repo "$REPO" \
  --title "Release v0.2.0 â€” KPI, Attendance & Settings" \
  --notes "## v0.2.0 â€” March 11â€“13, 2026

### New
- Track your KPIs â€” add entries, view goals, filter by date
- Edit education, work experience, and skills
- Download your resume as PDF
- Crop and update your profile picture
- Privacy policy, terms, and contact info in Settings
- About Us page with company info
- Delete your account from Settings
- Attendance timer keeps running on your lock screen
- New home screen with greeting, quick links, and your stats
- Works offline â€” data is saved, tap retry when back online
- Filter attendance and KPIs by date or status

### Improved
- Connected to live server â€” data syncs with the company
- Opens in light mode and Arabic by default
- Pull-to-refresh works smoothly
- Faster app startup

### Simplified
- App now focuses on profile, KPIs, and attendance"

echo "Creating release v0.3.0..."
gh release create v0.3.0 --verify-tag --repo "$REPO" \
  --title "Release v0.3.0 â€” Locale-Aware Profile, Multi-Skill Add & UX Improvements" \
  --notes "## v0.3.0 â€” March 15, 2026

### New
- Add multiple skills at once with the chip-input sheet
- Watch profile videos inside the app â€” no external player needed
- Search nationalities with a quick-filter dropdown
- Better date input for birth date, experience, and education
- Country field added to experience form

### Improved
- Profile data refreshes automatically when you switch language
- Skills always show their names regardless of language
- Modern bottom navigation bar with updated logo
- Cleaner button styles and text throughout the app

### Fixed
- Profile data no longer disappears when switching English â†” Arabic
- Skills no longer show empty circles after language switch
- Phone number field displays correctly in Arabic mode
- Video playback works on Android 11+"

echo "Creating release v0.4.0..."
gh release create v0.4.0 --verify-tag --repo "$REPO" \
  --title "Release v0.4.0 â€” Profile UX Overhaul, Essential Data Wizard & AppToast" \
  --notes "## v0.4.0 â€” March 26, 2026

### New
- Get Started screen â€” choose Login, Create Account, or Google Sign-In
- Post-registration wizard collects your essential profile data in 4 steps
- Review screen shows your submitted data and AI translation status
- Profile sections grouped with clear labels for easy navigation
- Portfolio tab with collapsible sections and item count badges
- Quick-action chips on profile page for fast editing
- Tap experience or education items to see full details
- In-app notification banner replaces old pop-up messages
- Delete your account permanently from Settings

### Improved
- Edit profile forms organized into labeled groups with sticky save button
- Experience and education forms are now full-screen with collapsible sections
- Empty sections now show helpful prompts and an Add button
- Validation and error messages appear in your selected language
- Nationality dropdown shows country flags for quick recognition
- Fewer loading spinners â€” smarter data fetching across the app

### Fixed
- Registration now correctly proceeds to the setup wizard
- Name fields validate language characters to prevent data issues
- Translation badge only shows on fields that actually need translation
- Phone number no longer reverses digits in Arabic mode"

echo "Creating/updating release v0.4.1..."
gh release create v0.4.1 --verify-tag --repo "$REPO" \
  --title "Release v0.4.1 â€” Offline-First, Bug Fixes & Security Hardening" \
  --notes "## v0.4.1 â€” April 5, 2026

### New
- Works offline â€” profile, KPIs, and attendance data stay available without internet
- Check-in/out and KPI changes are queued offline and synced when you reconnect
- Connection banner appears at the top when you go offline
- PDF resume cached after first view â€” readable without internet

### Improved
- Google Sign-In shows the real error instead of a generic message
- Network error messages are specific (timeout vs. no internet)
- KPI entries and actions now appear in your selected language
- Profile photo appears consistently on Home and Settings

### Fixed
- Attendance status labels update immediately when you switch language
- Attendance timer notification stops correctly on logout and account deletion
- Switching accounts no longer shows the previous user's cached data
- Add Skill dialog is now fully translated in Arabic mode
- 401 interceptor no longer wipes auth token on wrong-password login attempts
- GoRouter debug logging disabled in production builds

### Security
- R8/ProGuard rules added for release builds
- HTTPS-only enforced via network_security_config.xml
- Sentry trace sample rate 20% in production (was 100%)" 2>/dev/null \
|| gh release edit v0.4.1 --repo "$REPO" \
  --title "Release v0.4.1 â€” Offline-First, Bug Fixes & Security Hardening" \
  --notes "## v0.4.1 â€” April 5, 2026

### New
- Works offline â€” profile, KPIs, and attendance data stay available without internet
- Check-in/out and KPI changes are queued offline and synced when you reconnect
- Connection banner appears at the top when you go offline
- PDF resume cached after first view â€” readable without internet

### Improved
- Google Sign-In shows the real error instead of a generic message
- Network error messages are specific (timeout vs. no internet)
- KPI entries and actions now appear in your selected language
- Profile photo appears consistently on Home and Settings

### Fixed
- Attendance status labels update immediately when you switch language
- Attendance timer notification stops correctly on logout and account deletion
- Switching accounts no longer shows the previous user's cached data
- Add Skill dialog is now fully translated in Arabic mode
- 401 interceptor no longer wipes auth token on wrong-password login attempts
- GoRouter debug logging disabled in production builds

### Security
- R8/ProGuard rules added for release builds
- HTTPS-only enforced via network_security_config.xml
- Sentry trace sample rate 20% in production (was 100%)"

echo ""
echo "Done. GitHub tags/releases are now:"
echo "  v0.1.0  â€” Initial Release (Feb 17)"
echo "  v0.2.0  â€” KPI, Attendance & Settings (Mar 11â€“13)"
echo "  v0.3.0  â€” Locale-Aware Profile, Multi-Skill Add (Mar 15)"
echo "  v0.4.0  â€” Profile UX Overhaul, Essential Data Wizard (Mar 26)"
echo "  v0.4.1  â€” Offline-First, Bug Fixes & Security (Apr 5)"

