class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.44.3-nkmk.3"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.44.3-nkmk.3/zellij-nkmk-0.44.3-nkmk.3-aarch64-apple-darwin.tar.gz"
      sha256 "8b99ddf9a3cb4937a740f99ded3bc1b3a5f5e2fe04a08002df70a1064c949d44"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.44.3-nkmk.3/zellij-nkmk-0.44.3-nkmk.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "936501958c5a070246549360babfff0fe5f2e4871bea50ad5c1f0f886ca9550c"
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
