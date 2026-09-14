class ZellijNkmkRc < Formula
  desc "Release candidate of the personal zellij fork (stable: zellij-nkmk)"
  homepage "https://github.com/noahkiss/zellij"
  url "https://github.com/noahkiss/zellij/archive/refs/tags/v0.45.1-nkmk.21-rc.1.tar.gz"
  version "0.45.1-nkmk.21-rc.1"
  sha256 "c894cc7fe859a204c40997327de861fce213557ee9ed254903441f2686159287"
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
  #
  # Homebrew 7 loads every formula for every OS and arch when a tap is added,
  # so the formula needs a url that is valid everywhere. The source tarball is
  # that url. The prebuilt tarballs below override it on the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.21-rc.1/zellij-nkmk-0.45.1-nkmk.21-rc.1-aarch64-apple-darwin.tar.gz"
      sha256 "7e2973b0a136f30ada80d00afdec13dff97a064722d092ccf40896f2e33cee0a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.21-rc.1/zellij-nkmk-0.45.1-nkmk.21-rc.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "30a1444c6c086af8689d150b5ce65772260b8820d2eeceeb332a06f64d372c52"
    end
  end

  conflicts_with "zellij", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk-source", because: "both install a zellij binary"

  def install
    # The source tarball poured, which means no prebuilt override matched.
    unless File.exist?("zellij")
      odie "no prebuilt zellij for this platform; brew install noahkiss/tap/zellij-nkmk-source"
    end
    bin.install "zellij"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zellij --version")
    system bin/"zellij", "setup", "--check"
  end
end
