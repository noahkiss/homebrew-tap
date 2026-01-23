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

## Notes

- Always set `CGO_ENABLED=0` for Go projects to avoid GCC compatibility issues
- The tap auto-syncs when users run `brew update`
