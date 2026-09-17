# AGENTS.md

Community fork of `hashicorp/homebrew-tap`. Serves `Formula/*.rb` and
`Casks/hashicorp-*.rb` via `brew tap`; adds a configurable download mirror
(`HOMEBREW_HASHICORP_TAP_MIRROR`) and a Renovate-driven version-bump pipeline.
See `README.md` for the user-facing pipeline description.

## Layout

- `Formula/`, `Casks/` - generated output. Don't hand-edit files here except
  `Formula/copywrite.rb` and `Formula/enos.rb`, which are GitHub-releases-sourced
  and outside `formula_templater`'s config (also excluded from Renovate via
  `ignorePaths` in `.github/renovate.json5`).
- `util/formula_templater/` - Go CLI that renders `Formula/*.rb` and
  `Casks/hashicorp-*.rb` from `config.hcl` + the templates in `templates/`.
  Regenerate a file after editing a template:
  ```sh
  cd util/formula_templater && go build
  ./formula_templater [-cask] <product> <version> ./config.hcl > ../../Formula/<product>.rb
  ```
- `lib/hashicorp_mirror.rb` - shared `HashicorpMirror.url` helper, loaded via
  `require_relative "../lib/hashicorp_mirror"` from every generated formula/cask
  to avoid duplicating the mirror env-var lookup per file.
- `.github/renovate.json5` - custom regex managers + a custom datasource
  querying `api.releases.hashicorp.com` directly (no auth needed). See
  "Testing Renovate locally" below before touching this file - the Handlebars/JSONata
  templates fail silently (`no-result`, empty `{}`) rather than throwing, so
  changes here must be dry-run tested, never shipped on faith.
- `.github/workflows/renovate-sync.yml` - runs on Renovate's PRs, regenerates
  the bumped file with `formula_templater`, force-pushes back onto the PR
  branch using the `TAP_SYNC_DEPLOY_KEY` deploy key (not `GITHUB_TOKEN` -
  see the workflow's header comment for why).
- `.github/workflows/ci.yml` - builds/tests the Go tool, runs `brew audit --strict`
  against every formula/cask via a symlinked local tap.
- `.github/workflows/zizmor.yml` - hardening gate for `.github/**` itself.

## Commit messages

Semantic commits (`type(scope): summary`). Common types: `feat`, `fix`,
`chore`, `docs`, `ci`. Renovate's own commits already follow this
(`chore(deps): ...`) - match it for consistency in the dashboard/PR history.

## Verifying a change

```sh
cd util/formula_templater && go build && go test ./... && gofmt -l .
```

Then, for template/config.hcl changes, regenerate every committed file (see
`util/formula_templater/Makefile`'s `testdata` target for the golden-file
pattern) and confirm with `brew audit`/`brew style` - see "Testing Renovate
locally" for the Docker one-liner, same container `ci.yml` uses.

## Testing Renovate locally

`.github/renovate.json5`'s custom managers/datasource are Handlebars +
JSONata expressions that Renovate does not validate beyond JSON schema -
a broken template just returns `no-result` or `{}` with no error. Two enterprise-specific
gotchas already bit this repo once: HashiCorp's Releases API returns sibling
variants per version (`2.0.4+ent`, `2.0.4+ent.fips1403`, `2.0.6+ent.musl`)
that are not sequential releases - `customDatasources` must filter to the
plain `+ent` variant or Renovate will "bump" to a same-version FIPS/musl
sibling and merge a no-op. Always dry-run before pushing a config change:

```sh
# renovate-config-validator needs Node >=24; npx's cached install may pull whatever
# `node --version` you have, so pin one if it's older (npm warn EBADENGINE is the tell).
mise exec node@24 -- npx --yes -p renovate@latest -- renovate-config-validator .github/renovate.json5

# Full extraction dry-run against this checkout, no GitHub token/API calls needed
# for basic validation (add a token via `RENOVATE_TOKEN`/`gh auth token` to also
# check GitHub-hosted deps like the actions in workflows).
LOG_LEVEL=debug RENOVATE_CONFIG_FILE=.github/renovate.json5 \
  mise exec node@24 -- npx --yes -p renovate@latest -- renovate --platform=local --dry-run=full \
  > /tmp/renovate.log 2>&1

grep -i "no-result\|error" /tmp/renovate.log   # must be empty
grep '"depName"' /tmp/renovate.log | sort -u    # sanity-check every dep name looks like a product, not a raw filename
```

To test a single Handlebars/JSONata template in isolation (faster than a full
dry-run when iterating on one manager):

```sh
mkdir -p /tmp/rt && cd /tmp/rt && npm init -y >/dev/null && npm install renovate jsonata json5 >/dev/null
node -e "
import('renovate/dist/modules/manager/custom/regex/index.js').then(async ({extractPackageFile}) => {
  const content = require('fs').readFileSync('/path/to/Formula/vault.rb', 'utf8');
  const config = { /* one customManagers entry from renovate.json5 */ };
  console.log(await extractPackageFile(content, 'Formula/vault.rb', config));
});
"
```

Key gotchas discovered building this pipeline (all still apply if you touch
`renovate.json5` again):

- `packageFile` in a Handlebars template is the **basename only** (docs call
  it "Filename of the matched file"); the full relative path is
  `packageFileDir + '/' + packageFile`. Assuming it's the full path silently
  produces the wrong `depName`/`packageName`.
- Renovate's regex manager matches the **whole file**, not line-by-line - a
  `^` anchor in `matchStrings` matches file-start, not line-start. Use
  `(?:^|\n)` instead.
- Renovate's regex engine (RE2) has no lookahead/lookbehind support at all.
- `managerFilePatterns` needs Renovate ≥40.2.0; older CLI installs (check
  `npx renovate --version`) silently reject it as an unknown field.
- The Mend-hosted free app never runs `postUpgradeTasks`/scripts (by design,
  permanently) - that's why the sync work lives in a separate GitHub Actions
  workflow instead of Renovate itself.

If none of this makes sense to reproduce for a specific failure, it's
reasonable to extract this section into a dedicated skill - it hasn't been
needed often enough yet to justify that split.
