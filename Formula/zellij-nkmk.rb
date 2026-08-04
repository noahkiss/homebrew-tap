class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.44.3-nkmk.4"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.44.3-nkmk.4/zellij-nkmk-0.44.3-nkmk.4-aarch64-apple-darwin.tar.gz"
      sha256 "07209ad7c8b3b19e4b9b71aa7f7bed9e00f6db33205021597486ec41bc4da93c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.44.3-nkmk.4/zellij-nkmk-0.44.3-nkmk.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "40d1312bb10f61121a00f4c0eb69a27e12c38b67fa92ad3c965f9c9cf457db80"
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
