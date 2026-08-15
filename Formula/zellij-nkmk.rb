class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.45.0-nkmk.9"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.9/zellij-nkmk-0.45.0-nkmk.9-aarch64-apple-darwin.tar.gz"
      sha256 "f16c13d54aea0c8142a367b68eb1daab04012c2e289e72f372042706e0c886b1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.9/zellij-nkmk-0.45.0-nkmk.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2b2f897f63310dbf7c6a4b73346ff1e943636f84360eca9aa0bce3d68d2867bb"
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
