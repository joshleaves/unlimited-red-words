# Napkin

## Corrections
| Date | Source | What Went Wrong | What To Do Instead |
|------|--------|----------------|-------------------|
| 2026-03-10 | self | Assumed `.claude/napkin.md` already existed in this repo | Create the repo napkin immediately when missing, before continuing deeper work |

## User Preferences
- Reply in the same language as the user.
- Be concise.
- Use two-space indentation.
- For TypeScript package tooling, prefer `bun`/`bunx`.

## Patterns That Work
- When a frontend bug only appears in production, fetch the rendered HTML to confirm the actual scripts and generated markup before patching source files.
- For this blog, disabling `pwa.cache.enabled` is the clean way to stop stale content and also unregister existing service workers on the next visit.
- For this blog, `pwa.enabled: false` is better still: it removes the PWA notification UI and stops injecting the app script entirely.
- If PWA is turned off after users already visited, keep a tiny temporary unregister/clear-cache snippet in the layout so old service workers are actually cleaned up.

## Patterns That Don't Work
- Trusting local source includes without checking the final rendered document can miss duplicated assets introduced by layout overrides.
- Assuming local wrappers still match the upstream Chirpy theme API is risky; verify the actual served bundle when UI hooks stop responding.

## Domain Notes
- Pages build log (2026-11-01): `.ruby-version` pins 3.4.8 and Ruby compilation takes 3m23s. Pages build cache does not document Ruby/asdf or Bundler caching; prefer a preinstalled Ruby version if compatible (v3: 3.4.4; v2: 3.2.2 per current docs). Node 18.17.1/pnpm 8.7.1 in this log suggest the v2 image; confirm dashboard before changing.
- This repo is a Jekyll blog based on `jekyll-theme-chirpy`.
- `jekyll-seo-tag` 2.9.0 resolves `image.path` without leading `/` relative to `page.url` (e.g. `/posts/.../file.png`), which can break social image URLs if not rewritten.
