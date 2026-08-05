class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.44.3-nkmk.6"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.44.3-nkmk.6/zellij-nkmk-0.44.3-nkmk.6-aarch64-apple-darwin.tar.gz"
      sha256 "0758c24c4fca6e926aa0ec8e425fa4d092cc84da5c5fcedc688e5f18e3eacd46"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.44.3-nkmk.6/zellij-nkmk-0.44.3-nkmk.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "69032a26b2413bdfc7a150d4493f6c6caf4d95a59fda3b2ef93a2bfc9004af4e"
    end
  end

  conflicts_with "zellij", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk-source", because: "both install a zellij binary"

  def install
    bin.install "zellij"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zellij --version")
    system bin/"zellij", "setup", "--check"
  end
end
