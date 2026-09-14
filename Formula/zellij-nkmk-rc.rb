class ZellijNkmkRc < Formula
  desc "Release candidate of the personal zellij fork (stable: zellij-nkmk)"
  homepage "https://github.com/noahkiss/zellij"
  url "https://github.com/noahkiss/zellij/archive/refs/tags/v0.45.1-nkmk.20-rc.2.tar.gz"
  version "0.45.1-nkmk.20-rc.2"
  sha256 "cf66308c637707f444e397e6d60e026f943d972183731eb6eb10d375d2d7a0f2"
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
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.20-rc.2/zellij-nkmk-0.45.1-nkmk.20-rc.2-aarch64-apple-darwin.tar.gz"
      sha256 "851e1ebf5128900be06fecd00a2014751a49a1cb8c85f2582b718a12d1907601"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.20-rc.2/zellij-nkmk-0.45.1-nkmk.20-rc.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4d88845d4eee103025777239aff5c5eb40ccf3597cefab097d9af799dadbe9ba"
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
