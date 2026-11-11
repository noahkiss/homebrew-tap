# Python/uv formulas

See `Formula/basic-memory.rb`. A project with a large `uv.lock` is impractical to express as
enumerated `resource` blocks, so instead: `depends_on "uv" => :build` plus a pinned
`python@3.13`, then `uv sync --locked --no-dev --no-editable --python <brew python>` (plus
`--extra <name>` for each optional extra the formula ships; `basic-memory` ships `server`) with
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
  is read-only on the source repository and nothing else. The maintainer keeps a second copy of the
  private half outside GitHub; rotate both together.
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
