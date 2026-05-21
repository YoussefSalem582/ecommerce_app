# Update Documentation

Update all mandatory documentation files after a change has been made.

## When to Use

- User says "update docs", "update changelog", "document this"
- After completing any feature, fix, refactor, or meaningful change
- As the final step of any other skill (add-feature, add-api, etc.)

## Required Files (always update all three)

### 1 â€” CHANGELOG.md

Location: `CHANGELOG.md`

Find the current unreleased version section (or the latest version). Add the change under the correct subsection:

- `### Added` â€” new features, new endpoints, new screens
- `### Changed` â€” modifications to existing behavior
- `### Fixed` â€” bug fixes
- `### Removed` â€” deleted code or features

Format:
```markdown
### Added
- feat(feature-name): short description of what was added
```

### 2 â€” DOCUMENTATION_UPDATE_SUMMARY.md

Location: `shopflow_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md`

Add a new dated entry at the TOP of the file:

```markdown
## YYYY-MM-DD â€” <short title>

**What changed:** <1-2 sentences>

**Files created:**
- `path/to/new/file.dart`

**Files modified:**
- `path/to/changed/file.dart`

**Key decisions:**
- <any notable architectural or design decision>
```

### 3 â€” CURRENT_STATUS.md

Location: `shopflow_readme_files/CURRENT_STATUS.md`

Update the relevant sections:
- Feature status table (if a feature was added/completed)
- Metrics (file counts, coverage, etc.) if changed
- "Last updated" date at the top

## Conditional Files (update only when relevant)

| File | Update when |
|------|------------|
| `shopflow_readme_files/01_folder_structure.md` | Files/folders added, moved, or removed |
| `shopflow_readme_files/02_architecture.md` | Architecture patterns changed |
| `shopflow_readme_files/04_how_to_add_new_api.md` | API integration pattern changed |
| `shopflow_readme_files/06_how_to_change_theme_colors.md` | New design tokens added |
| `shopflow_readme_files/07_how_to_create_reusable_component.md` | New shared widget added |
| `shopflow_readme_files/08_security_and_environment.md` | New secret or auth change |
| `shopflow_readme_files/09_api_endpoints.md` | New endpoint added |
| `shopflow_readme_files/10_testing.md` | New test patterns, infrastructure, or coverage areas added |

## Instructions

1. Ask the user what change was made (if not already clear from context)
2. Determine the correct version section in CHANGELOG.md
3. Write concise, factual entries â€” no fluff
4. Always update all three required files
5. Only update conditional files if the change is relevant to them

