class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.45.0-nkmk.14"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.14/zellij-nkmk-0.45.0-nkmk.14-aarch64-apple-darwin.tar.gz"
      sha256 "80c58b5bc525cfe28e3559343012dc36c960973af9cf4521cc50cff2c7ea5d9b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.14/zellij-nkmk-0.45.0-nkmk.14-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fbd59feded12f7abea92d0e7b7056031c86f848d76abd89242e404c55a004ba6"
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
