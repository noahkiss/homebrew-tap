class ZellijNkmkRc < Formula
  desc "Release candidate of the personal zellij fork (stable: zellij-nkmk)"
  homepage "https://github.com/noahkiss/zellij"
  version "0.45.0-nkmk.13-rc.1"
  license "MIT"

  # Points at whatever `-rc.` tag is currently being proved on a real Mac. It is
  # bumped by the same workflow as zellij-nkmk, from the same published `.sha256`
  # assets, and only ever by a tag carrying `-rc.`. Seeded at the last final
  # release so the formula is installable before the first candidate exists.
  #
  # To prove a candidate, and to go back afterwards:
  #
  #   brew unlink zellij-nkmk && brew install noahkiss/tap/zellij-nkmk-rc
  #   brew uninstall zellij-nkmk-rc && brew link zellij-nkmk
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.13-rc.1/zellij-nkmk-0.45.0-nkmk.13-rc.1-aarch64-apple-darwin.tar.gz"
      sha256 "ba8d30cce211a1a22894d9ea756facaca3be05920fa4045bb906939f8bfa7c51"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.13-rc.1/zellij-nkmk-0.45.0-nkmk.13-rc.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "151f2e167a2f1ec8b6d294b9d3d268f5ecd6d7d9e94d007b88d26f25da6db286"
    end
  end

  conflicts_with "zellij", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk-source", because: "both install a zellij binary"

  def install
    bin.install "zellij"
  end

  test do
    # The tag carries the candidate number; the binary reports only the version
    # its Cargo.toml was bumped to, so `-rc.N` is not in `zellij --version`.
    assert_match version.to_s.sub(/-rc\.\d+\z/, ""), shell_output("#{bin}/zellij --version")
    system bin/"zellij", "setup", "--check"
  end
end
