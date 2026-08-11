class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.45.0-nkmk.3"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.3/zellij-nkmk-0.45.0-nkmk.3-aarch64-apple-darwin.tar.gz"
      sha256 "daf24bc990ed13f2ab807bb4a5daee179c3f8bd9d87ef88ced0f226a5fd7008b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.3/zellij-nkmk-0.45.0-nkmk.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f4f2016acb76eabca6cc947f048ea6795f7da222f86e9d6b1b1def90be46cc53"
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
