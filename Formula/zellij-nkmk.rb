class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.44.3-nkmk.7"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.44.3-nkmk.7/zellij-nkmk-0.44.3-nkmk.7-aarch64-apple-darwin.tar.gz"
      sha256 "5f130d8e2962d83d7e2ba7f2fb4a6d2b8501302b1de7f34061d38b393d5a801e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.44.3-nkmk.7/zellij-nkmk-0.44.3-nkmk.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "184fbae62b10c1146a44b87114836b715c20c1b906b95ebc7da5c0b128a8b39b"
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
