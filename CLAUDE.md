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

When releasing a new version:
1. Update `url` with new tag
2. Update `sha256` with new tarball hash
3. Commit and push

## Python/uv formulas

See `Formula/basic-memory.rb`. A project with a large `uv.lock` is impractical to express as
enumerated `resource` blocks, so instead: `depends_on "uv" => :build` plus a pinned
`python@3.13`, then `uv sync --locked --no-dev --no-editable --python <brew python>` with
`UV_PROJECT_ENVIRONMENT=libexec`, `UV_CACHE_DIR=buildpath/"uv-cache"`, and
`UV_PYTHON_DOWNLOADS=never`. Symlink the console scripts with `bin.install_symlink`. If the
project derives its version from git, set the backend's bypass env var (for
`uv-dynamic-versioning`: `UV_DYNAMIC_VERSIONING_BYPASS = version.to_s`) — a tarball has no `.git`.

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
