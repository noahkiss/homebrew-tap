class YadmNkmk < Formula
  desc "Dotfiles manager for one setup shared across personal, work and client machines"
  homepage "https://github.com/noahkiss/yadm"
  # The sha256 is a placeholder until the first release tag, which dispatches bump.yml to
  # rewrite the url and sha256 from the published tarball.
  url "https://github.com/noahkiss/yadm/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "0e194070988c323a10400759da59e41ea7089128356961442b02794a91b32730"
  license "MIT"
  head "https://github.com/noahkiss/yadm.git", branch: "main"

  depends_on "go" => :build

  # Both install bin/yadm. A formula named yadm here could not sit beside the core one at
  # all: Homebrew refuses two formulae of one name from different taps.
  conflicts_with "yadm", because: "both install a `yadm` binary"

  def install
    ENV["CGO_ENABLED"] = "0"
    # std_go_args adds -s -w.
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"yadm"), "./cmd/yadm"
  end

  def caveats
    <<~EOS
      This yadm is unrelated to the yadm in homebrew/core. Both install `yadm`, so only one
      can be linked at a time. Both kegs stay installed.

      Install this one while the core yadm is installed:
        brew unlink yadm && brew install noahkiss/tap/yadm-nkmk

      Switch back to the core yadm:
        brew unlink yadm-nkmk && brew link yadm

      Switch to this one again:
        brew unlink yadm && brew link yadm-nkmk
    EOS
  end

  test do
    assert_equal "yadm #{version}", shell_output("#{bin}/yadm version").strip
  end
end
