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

## Patterns That Don't Work
- Trusting local source includes without checking the final rendered document can miss duplicated assets introduced by layout overrides.

## Domain Notes
- This repo is a Jekyll blog based on `jekyll-theme-chirpy`.
