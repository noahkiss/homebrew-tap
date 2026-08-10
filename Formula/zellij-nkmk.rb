class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.45.0-nkmk.1"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.1/zellij-nkmk-0.45.0-nkmk.1-aarch64-apple-darwin.tar.gz"
      sha256 "3cd62cf8e3dc64ed73d820a36f3824ffd905f2d90fc6bfa6789df78b94b3e221"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.1/zellij-nkmk-0.45.0-nkmk.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7e2141183a7b735c36335d5338fba09631468b71fbe92a9f4f97830d75be3276"
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
