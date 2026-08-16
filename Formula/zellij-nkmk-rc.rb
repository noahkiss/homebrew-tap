class ZellijNkmkRc < Formula
  desc "Release candidate of the personal zellij fork (stable: zellij-nkmk)"
  homepage "https://github.com/noahkiss/zellij"
  version "0.45.0-nkmk.11"
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
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.11/zellij-nkmk-0.45.0-nkmk.11-aarch64-apple-darwin.tar.gz"
      sha256 "ddae97c961207b60d5de7089be5e7c2f0acafda68de9ef1a2990b4da8ac03764"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.11/zellij-nkmk-0.45.0-nkmk.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "21b09ba0ef1f7c906677c10803ddea7f6053be348c6d604322301ce33aa8e3ab"
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
