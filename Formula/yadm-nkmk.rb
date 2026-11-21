class YadmNkmk < Formula
  desc "Dotfiles manager for one setup shared across personal, work and client machines"
  homepage "https://github.com/noahkiss/yadm"
  # Homebrew loads every formula for every OS and arch, so the top-level url must hold
  # everywhere: it is the tag's source tarball, which Linux builds from. macOS overrides it
  # with the release's Developer ID signed, notarized binary, whose code identity stays the
  # same across upgrades. bump.yml rewrites every url and sha256 from the release. Keep the
  # version out of comments: bump.yml refuses a rewrite that leaves the old one in the file.
  url "https://github.com/noahkiss/yadm/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "f27e1eec41953c7d63b40e8b6673d3c75549548696baf0669fa145686ad27b95"
  license "MIT"

  head do
    url "https://github.com/noahkiss/yadm.git", branch: "main"

    depends_on "go" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/noahkiss/yadm/releases/download/v0.1.7/yadm_0.1.7_darwin_arm64.tar.gz"
      sha256 "269cf3b3c0dc7ee0eb63174d4688d1ffe2551a6e952acf2dd3567159fc15c047"
    end
    on_intel do
      url "https://github.com/noahkiss/yadm/releases/download/v0.1.7/yadm_0.1.7_darwin_amd64.tar.gz"
      sha256 "a8c39337f653a0a87bcfc6c9c6042d0523026905e2ee810ea65c3686ca57e4ca"
    end
  end

  on_linux do
    depends_on "go" => :build
  end

  # Both install bin/yadm. A formula named yadm here could not sit beside the core one at
  # all: Homebrew refuses two formulae of one name from different taps.
  conflicts_with "yadm", because: "both install a `yadm` binary"

  def install
    if OS.mac? && !build.head?
      # The release archive: the signed binary goes in as it is, so its signature survives.
      bin.install "yadm"
    else
      ENV["CGO_ENABLED"] = "0"
      # std_go_args adds -s -w.
      ldflags = "-X main.version=#{version}"
      system "go", "build", *std_go_args(ldflags:, output: bin/"yadm"), "./cmd/yadm"
    end
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
    if OS.mac? && !version.head?
      # A release binary carries the team's Developer ID and its fixed identifier.
      sig = shell_output("/usr/bin/codesign -dv --verbose=2 #{bin}/yadm 2>&1")
      assert_match(/^TeamIdentifier=2Z88BYP37C$/, sig)
      assert_match(/^Identifier=com\.nkmkdigital\.yadm$/, sig)
    end
  end
end
