class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.45.0-nkmk.17"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.17/zellij-nkmk-0.45.0-nkmk.17-aarch64-apple-darwin.tar.gz"
      sha256 "387237bfc886ca27837b781133476bcc5a71bc162c3cd21564585585c36f8dc0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.17/zellij-nkmk-0.45.0-nkmk.17-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6efff62c2ab994328e5230267594d83a4ab120e7ab4714cb4be13aa10ea68ecf"
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
