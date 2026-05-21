# Update Documentation

After completing a code change, update:

1. **`CHANGELOG.md`** — `[Unreleased]` or current version section
2. **`shopflow_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md`** — dated entry at top (what/why/files)
3. **`shopflow_readme_files/CURRENT_STATUS.md`** — version from `pubspec.yaml`, feature matrix

Conditionally update guides in `shopflow_readme_files/` if process changed (see `.agents/rules/documentation-updates.md`).

Verify:

```powershell
.\scripts\check_docs_freshness.ps1
```
