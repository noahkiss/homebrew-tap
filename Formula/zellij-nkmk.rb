class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.45.0-nkmk.15"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.15/zellij-nkmk-0.45.0-nkmk.15-aarch64-apple-darwin.tar.gz"
      sha256 "44f03453d76a54ee9a6a5f2f7f890c14f8f5385ea681d2496d5e1249aa7aa918"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.15/zellij-nkmk-0.45.0-nkmk.15-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "95f84ee2e8e6113f185968d08b518f8704b425f9093477266d5625eef143b5ea"
    end
  end

  conflicts_with "zellij", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk-source", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk-rc", because: "both install a zellij binary"

  def install
    bin.install "zellij"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zellij --version")
    system bin/"zellij", "setup", "--check"
  end
end
