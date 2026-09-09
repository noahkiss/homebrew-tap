class ZellijNkmkRc < Formula
  desc "Release candidate of the personal zellij fork (stable: zellij-nkmk)"
  homepage "https://github.com/noahkiss/zellij"
  version "0.45.1-nkmk.19-rc.1"
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
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.19-rc.1/zellij-nkmk-0.45.1-nkmk.19-rc.1-aarch64-apple-darwin.tar.gz"
      sha256 "f38e35b36fcef211e532f058beea9586fa61107c4cea94d7a6ca74d9917a8618"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.19-rc.1/zellij-nkmk-0.45.1-nkmk.19-rc.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "913b67f7df81354d1b3acfec7e309fae05fa04be331b7bf54c8d5a33e8672e13"
    end
  end

  conflicts_with "zellij", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk-source", because: "both install a zellij binary"

  def install
    bin.install "zellij"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zellij --version")
    system bin/"zellij", "setup", "--check"
  end
end
