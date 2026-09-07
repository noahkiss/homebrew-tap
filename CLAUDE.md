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

  depends_on "go" => :build  # or other dependencies

  def install
    ENV["CGO_ENABLED"] = "0"  # for Go projects
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
`brew install` on macos-14 and ubuntu-latest, and commit with a rebase retry. A failed verify
commits nothing. Read the header comment of each workflow before changing it.

| Workflow | Formulae | What it needs from the release |
|---|---|---|
| `bump.yml` | any formula with one `url` and one `sha256` (`markshift` today) | the asset at the old url with the version swapped; it downloads and hashes it, then runs `brew test` |
| `bump-zellij.yml` | `zellij-nkmk`, `zellij-nkmk-rc`, `zellij-nkmk-source` | per-platform tarballs plus their `.sha256` assets; a final tag also rehashes the source tarball |

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

`basic-memory` is still bumped by hand (`url` + `sha256`); its install path is under review.

Every `uses:` in both workflows is pinned to a full commit SHA with a `# vX.Y.Z` comment,
the same policy as `noahkiss/workflows`. `.github/dependabot.yml` raises a grouped weekly
bump; review the version comment, not the hash.

The verify job runs the formula's `test do` block, so the block must assert something the
release can fail. `markshift`'s asserts `--version` matches the formula version; that caught a
published tarball whose binary reported the previous version.

## Python/uv formulas

See `Formula/basic-memory.rb`. A project with a large `uv.lock` is impractical to express as
enumerated `resource` blocks, so instead: `depends_on "uv" => :build` plus a pinned
`python@3.13`, then `uv sync --locked --no-dev --no-editable --python <brew python>` with
`UV_PROJECT_ENVIRONMENT=libexec`, `UV_CACHE_DIR=buildpath/"uv-cache"`, and
`UV_PYTHON_DOWNLOADS=never`. Symlink the console scripts with `bin.install_symlink`. If the
project derives its version from git, set the backend's bypass env var (for
`uv-dynamic-versioning`: `UV_DYNAMIC_VERSIONING_BYPASS = version.to_s`) — a tarball has no `.git`.

**Private source repo — clone over SSH, no token.** `basic-memory`'s repository is private, so
the archive-tarball `url` would 404. Its `url` is `ssh://git@github.com/<owner>/<repo>.git` with
`tag:` (sets the version) and `revision:` (the pin; replaces `sha256`). Homebrew's git strategy
runs the user's git with their SSH agent, so the machine's GitHub key is the only credential and
the formula stays secret-free. A bump edits `tag` and `revision` together
(`git rev-parse vX.Y.Z^{commit}`), not `url` and `sha256`. Do not put a token in a formula: this
tap is public.

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
