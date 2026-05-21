# How to Create a Reusable Component

1. Check `lib/core/widgets/` — extend or compose existing widgets
2. Feature-only UI stays under `lib/features/<name>/presentation/widgets/`
3. Use `AppPalette` / theme `textTheme` for colors and type
4. Add `TestKeys` for integration tests when needed
5. Add ARB strings for any user-visible copy
