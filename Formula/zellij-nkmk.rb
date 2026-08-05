class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.44.3-nkmk.5"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.44.3-nkmk.5/zellij-nkmk-0.44.3-nkmk.5-aarch64-apple-darwin.tar.gz"
      sha256 "9924c68bc821f60bf71d3be19284d585a5edb1c82ca78f06bbb0496f1db39c77"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.44.3-nkmk.5/zellij-nkmk-0.44.3-nkmk.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "989d7c0eaaf992bc338d0abe78a2dc6b6af4d0133f91209abadbebb902ebbd57"
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
