# Unlimited Red Words — Agent Notes

## Git policy (strict)

- **NEVER commit or push on this repository.** Always leave changes unstaged/uncommitted
  and let the user review and commit themselves. Do not run `git commit`, `git push`,
  `git merge`, or any history-rewriting command. Reading git state (`git status`,
  `git diff`, `git log`) is fine.

## CSS / Bootstrap build (important)

This site uses the Jekyll Chirpy theme, which splits CSS by environment:

- **Development** (`JEKYLL_ENV` unset): Bootstrap is loaded from a CDN at
  runtime; the SCSS bundle is `main` only (no Bootstrap).
- **Production** (`JEKYLL_ENV=production`, which Cloudflare Pages uses): no CDN
  link; instead `assets/css/jekyll-theme-chirpy.scss` compiles `main.bundle`,
  which `@use`s `./vendors/bootstrap` (a *purged* Bootstrap) plus `main`.

The purged Bootstrap is **not** generated during the Jekyll build. It must be
regenerated locally and **committed**, otherwise production falls back to the
gem's stale purged copy and custom Bootstrap classes used in `_layouts` /
`_includes` (e.g. `mb-2`, `table-responsive`, series utilities) go missing.

### Regenerate after changing HTML/templates/JS

```sh
npm run build:css   # runs node purgecss.js
```

This writes `_sass/vendors/_bootstrap.scss` (and relies on `_sass/main.bundle.scss`
to wire it into the bundle). Commit both files together with your change:

```sh
git add _sass/main.bundle.scss _sass/vendors/_bootstrap.scss
```

### Files involved

- `purgecss.js` — runs PurgeCSS over `node_modules/bootstrap/dist/css/bootstrap.min.css`,
  scanning project `_includes`, `_layouts`, `_javascript` *and* the installed
  `jekyll-theme-chirpy` gem's templates. Writes `_sass/vendors/_bootstrap.scss`.
- `purgecss.config.js` — legacy CLI config (unused; `npm run build:css` calls
  `purgecss.js`).
- `_sass/main.bundle.scss` — project override of the gem's bundle; imports the
  project's purged Bootstrap then `main`.
- `assets/css/jekyll-theme-chirpy.scss` — selects `main.bundle` (prod) vs `main`
  (dev) via `jekyll.environment`.

### Do not

- Do not delete or gitignore `_sass/vendors/_bootstrap.scss` or
  `_sass/main.bundle.scss` — production depends on them.
- Do not run only `npm run build` expecting CSS to update; `build:css` is a
  separate step and its output must be committed.
- Do not edit `_sass/vendors/_bootstrap.scss` by hand; regenerate it.