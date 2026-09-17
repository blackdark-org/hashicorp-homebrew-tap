# HashiCorp Homebrew Tap (community fork)

A community-maintained fork of [hashicorp/homebrew-tap](https://github.com/hashicorp/homebrew-tap),
with automated version updates and a configurable download mirror.

This exists because upstream hasn't taken a mirror/proxy option for the
hardcoded `releases.hashicorp.com` URLs - see
[hashicorp/homebrew-tap#265](https://github.com/hashicorp/homebrew-tap/issues/265),
[hashicorp/homebrew-tap#266](https://github.com/hashicorp/homebrew-tap/pull/266), and
[hashicorp/homebrew-tap#249](https://github.com/hashicorp/homebrew-tap/pull/249).

## Install

```sh
brew tap blackdark-org/hashicorp-homebrew-tap
brew install blackdark-org/hashicorp-homebrew-tap/<formula>
```

## Custom download mirror

Every formula and cask downloads from `https://releases.hashicorp.com` by
default. To use a mirror or internal proxy instead, set
`HOMEBREW_HASHICORP_TAP_MIRROR` before installing:

```sh
export HOMEBREW_HASHICORP_TAP_MIRROR="https://artifactory.example.com/hashicorp-releases"
brew install blackdark-org/hashicorp-homebrew-tap/vault
```

Only the base URL changes; the path structure
(`/<product>/<version>/<product>_<version>_<os>_<arch>.zip`) is unchanged, so
the mirror just needs to proxy `releases.hashicorp.com` verbatim. This is the
same env-var approach proposed upstream in
[hashicorp/homebrew-tap#266](https://github.com/hashicorp/homebrew-tap/pull/266)
and [#249](https://github.com/hashicorp/homebrew-tap/pull/249), neither of
which has been merged.

This tap never hosts binaries itself - it only points at a URL (upstream by
default, or your mirror). Enterprise-licensed formulae
(`vault-enterprise`, `consul-enterprise`, `nomad-enterprise`,
`boundary-enterprise`) work the same way; you still need your own entitlement
to run those binaries.

## How version updates work

[Renovate](./.github/renovate.json5) polls the [HashiCorp Releases API](https://api.releases.hashicorp.com)
and opens a PR bumping the `version "..."` line in the affected file.
Renovate can't compute per-architecture URLs or `sha256` values itself, so a
second workflow, [`renovate-sync.yml`](./.github/workflows/renovate-sync.yml),
runs on that PR, regenerates the file with `formula_templater`, and pushes the
result back onto the same branch using a deploy key (a plain `GITHUB_TOKEN`
push wouldn't retrigger CI). That push re-runs [`ci.yml`](./.github/workflows/ci.yml)'s
`brew audit`, and Renovate only auto-merges once it passes.

### One-time maintainer setup

A deploy key pair is already generated at `.github/deploy_key` (gitignored)
and `.github/deploy_key.pub` (tracked).

1. Add `.github/deploy_key.pub`'s contents as a repo deploy key with **write
   access** (Settings → Deploy keys).
2. Add `.github/deploy_key`'s contents as an Actions secret named
   `TAP_SYNC_DEPLOY_KEY` (Settings → Secrets and variables → Actions), then
   delete the local private key file - it only needs to exist in the secret.
3. Require the `CI` workflow's checks on `main` and enable "Allow auto-merge"
   for the repo (Settings → Branches / General).
4. Install the [Renovate GitHub App](https://github.com/apps/renovate) on
   this repository.

## Adding a new product

Add an entry to [`util/formula_templater/config.hcl`](./util/formula_templater/config.hcl),
then generate the file:

```sh
cd util/formula_templater && go build
./formula_templater [-cask] <product> <version> ./config.hcl > ../../Formula/<product>.rb
```

Renovate picks up future releases automatically once the file exists.
