# Homebrew Tap

Central tap for all custom Homebrew formulas under the `noahkiss` namespace.

## Adding a New Formula

1. Create `Formula/<name>.rb` following this template:

```ruby
class MyTool < Formula
  desc "Short description"
  homepage "https://github.com/noahkiss/<repo>"
  url "https://github.com/noahkiss/<repo>/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "<sha256>"
  license "MIT"

  depends_on "go" => :build # or other dependencies

  def install
    ENV["CGO_ENABLED"] = "0" # for Go projects
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "version", shell_output("#{bin}/<name> --version")
  end
end
```

2. Get the SHA256: `curl -sL <tarball-url> | sha256sum`

3. Commit and push to this repo

4. Users install with: `brew install noahkiss/tap/<name>`

## Updating a Formula

Do not hand-edit a formula that has a bump workflow. The workflows in
`.github/workflows/` rewrite the formula from the producer's release, prove it with a real
`brew install` on macos-14 and ubuntu-latest plus a tap-wide `brew readall`, and commit with a
rebase retry. A failed verify commits nothing. Read the header comment of each workflow before changing it.

| Workflow | Formulae | What it needs from the release |
|---|---|---|
| `bump.yml` | any formula with one `url` and one `sha256` (`markshift` today), and any cask in `Casks/` with one `version`, one `url` and one `sha256` (`quadcam` today) | the asset at the old url with the version swapped (for a cask, the url with `#{version}` expanded); it downloads and hashes it, then runs `brew test`, or for a cask `brew install --cask` plus the checks below |
| `bump-zellij.yml` | `zellij-nkmk`, `zellij-nkmk-rc`, `zellij-nkmk-source` | per-platform tarballs plus their `.sha256` assets; every tag also hashes the source tarball, which all three formulae pin (see below) |
| `bottle.yml` | `basic-memory` | nothing: it reads the private source tag with a deploy key and publishes the source archive and bottles on this tap's own release (see below) |

Producers fire these through `noahkiss/workflows/.github/workflows/dispatch-and-wait.yml`,
which injects a `request_id` and waits for the tap run to conclude. Both workflows echo that
id in their `run-name`; keep it there or the producer times out. The producer holds a PAT
with `workflow` scope on this repo, in a secret named `HOMEBREW_TAP_TOKEN`; the tap itself
commits with its own `GITHUB_TOKEN`. By hand:

```bash
gh workflow run bump.yml -R noahkiss/homebrew-tap -f formula=<name> -f tag=<tag>
gh workflow run bump-zellij.yml -R noahkiss/homebrew-tap -f tag=<tag>
```

A new single-source formula needs no new workflow: `bump.yml` reads the tag off the existing
url (`/releases/download/<tag>/` or `/archive/refs/tags/<tag>.tar.gz`), so keep one of those
two url shapes. Give the producer a release workflow that ends in a `dispatch-and-wait` call
with `inputs_json: {"formula":"<name>","tag":"<tag>"}`; `noahkiss/markshift` is the model.

**Every formula needs a top-level `url`.** Homebrew 7 loads each formula for every OS and
arch when the tap is added (`brew readall`), and a formula whose only `url` sits inside
`on_macos`/`on_linux` blocks fails that load with `formula requires at least a URL`, which
breaks `brew tap` for the whole tap. The prebuilt zellij formulae pin the source tarball as
their top-level `url` and override it per platform; their `install` refuses with a pointer
to `zellij-nkmk-source` when no override matched. Check the shape locally with:

```bash
brew readall noahkiss/tap && brew style noahkiss/tap && brew audit --strict noahkiss/tap/<name>
```

`basic-memory` is not bumped by `bump.yml`. `bottle.yml` owns it; see "Bottled formula" under Python/uv formulas.

Every `uses:` in every workflow is pinned to a full commit SHA with a `# vX.Y.Z` comment,
the same policy as `noahkiss/workflows`. `.github/dependabot.yml` raises a grouped weekly
bump; review the version comment, not the hash.

The verify job runs the formula's `test do` block, so the block must assert something the
release can fail. `markshift`'s asserts `--version` matches the formula version; that caught a
published tarball whose binary reported the previous version.

## Casks

Casks live in `Casks/<name>.rb`. `bump.yml` takes the cask name in its `formula` input; it
looks in `Formula/` first, then in `Casks/`. A cask's `url` may interpolate only
`#{version}`. The workflow rewrites the `version` and `sha256` lines and leaves the `url`
alone.

A cask has no `test do` block. The macOS verify leg installs the cask, runs every `binary`
it links with `--version` and requires the new version in the output, and fails if an
installed app carries `com.apple.quarantine` and `spctl --assess` rejects it. A notarized app
keeps the flag and passes. The Linux leg only runs `brew readall`.

**Unsigned apps.** Since Homebrew 5, homebrew/cask disables casks that fail Gatekeeper, and
`--no-quarantine` is gone. Third-party taps are not audited for this, but Homebrew still
quarantines every download. A cask for an ad-hoc-signed app removes the flag in
`postflight_steps`; `brew style` rejects the older `postflight do` block. A notarized app
(`quadcam` from its first Developer ID release) needs no such step:

```ruby
postflight_steps do
  run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/<App>.app"]
end
```

## Python/uv formulas

See `Formula/basic-memory.rb`. A project with a large `uv.lock` is impractical to express as
enumerated `resource` blocks, so instead: `depends_on "uv" => :build` plus a pinned
`python@3.13`, then `uv sync --locked --no-dev --no-editable --python <brew python>` with
`UV_PROJECT_ENVIRONMENT=libexec`, `UV_CACHE_DIR=buildpath/"uv-cache"`, and
`UV_PYTHON_DOWNLOADS=never`. Symlink the console scripts with `bin.install_symlink`. If the
project derives its version from git, set the backend's bypass env var (for
`uv-dynamic-versioning`: `UV_DYNAMIC_VERSIONING_BYPASS = version.to_s`) — a tarball has no `.git`.

**Bottled formula — `basic-memory`.** Its source repository is private, so its archive url answers 404 and no machine
should need a key to read it. `bottle.yml` publishes everything a machine needs on this tap's
own release instead. To release a new version:

1. Tag the release in the source repository (`vX.Y.Z`).
2. Dispatch the tap workflow:

   ```bash
   gh workflow run bottle.yml -R noahkiss/homebrew-tap -f formula=basic-memory -f tag=vX.Y.Z
   ```

The workflow checks the tag out with a read-only deploy key, uploads a `git archive` tarball to
the tap release `basic-memory-<version>`, and points the formula's `url` and `sha256` at it. It
then builds, tests and bottles the formula on each matrix runner, uploads the bottles to the same
release, writes the `bottle do` block and commits. A failed leg commits nothing. Do not edit
`url`, `sha256` or the bottle block by hand.

- **Deploy key.** The private half is the tap Actions secret `BASIC_MEMORY_DEPLOY_KEY`. The key
  is read-only on the source repository and nothing else. Its private half is also kept in the
  owner's password manager; rotate both together.
- **Matrix.** `macos-26` (arm64), the macOS 27 preview image and `ubuntu-latest` (x86_64). There
  is no `macos-27` label yet; the only macOS 27 runner is the `xcode-27` preview. Swap the label
  in the matrix once `macos-27` ships. The bottle OS tags come from `brew bottle`'s JSON.
- **Fallback.** A machine no bottle covers (Intel Mac, older macOS, arm64 Linux) builds from the
  release tarball with uv, as above. The tarball is public, so that build needs no credential.
- **Re-runs.** The release is reused. An existing source tarball is hashed, never replaced,
  because a committed formula may already pin it. Bottles are replaced on every run.

**macOS trap — Homebrew relocates dylib IDs and Rust wheels cannot take it.** After `install`,
Homebrew rewrites the `LC_ID_DYLIB` of every `MH_DYLIB` Mach-O in the keg to its absolute opt
path. Rust/maturin wheels (jiter, py-rust-stemmers, pydantic-core, tokenizers…) ship extension
modules as `MH_DYLIB` with a short `@rpath/...` id and no header padding, so the longer path does
not fit; ruby-macho raises and the raise aborts the whole relocation loop. There is no
formula-level opt-out — `skip_relocation` is bottle-only. Fix: set the id yourself where it fits,
and where it does not, delete the `LC_ID_DYLIB` command and flip the filetype to `MH_BUNDLE`,
then re-sign ad-hoc. Deleting that command is not optional: dyld rejects a bundle that still
carries it. See `relocate_macho_dylib_ids` in `Formula/basic-memory.rb`.

## Notes

- Always set `CGO_ENABLED=0` for Go projects to avoid GCC compatibility issues
- The tap auto-syncs when users run `brew update`
