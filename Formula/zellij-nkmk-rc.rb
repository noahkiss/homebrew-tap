class ZellijNkmkRc < Formula
  desc "Release candidate of the personal zellij fork (stable: zellij-nkmk)"
  homepage "https://github.com/noahkiss/zellij"
  version "0.45.0-nkmk.12-rc.3"
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
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.12-rc.3/zellij-nkmk-0.45.0-nkmk.12-rc.3-aarch64-apple-darwin.tar.gz"
      sha256 "c04753db857b6a1c99ea6f60b8d429f0abfc2ecc62960490f1c4d6bdf7a2252a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.12-rc.3/zellij-nkmk-0.45.0-nkmk.12-rc.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "48b6c238f1a020f47b7370b4e005dd13f1c57bbbe26fc7eedf7b1afa9a5b88da"
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
