class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  url "https://github.com/noahkiss/zellij/archive/refs/tags/v0.45.1-nkmk.26.tar.gz"
  version "0.45.1-nkmk.26"
  sha256 "4e6fc50f23ab16e552adf0ab2f591834bbc64d4ebfb369191c5ac220cd4b8c43"
  license "MIT"

  # Homebrew 7 loads every formula for every OS and arch when a tap is added,
  # so the formula needs a url that is valid everywhere. The source tarball is
  # that url. The prebuilt tarballs below override it on the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.26/zellij-nkmk-0.45.1-nkmk.26-aarch64-apple-darwin.tar.gz"
      sha256 "3f390beb162c1d4c3db21ad4a83156dbf4cbfb693b60ebc83c19faf150f2da45"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.26/zellij-nkmk-0.45.1-nkmk.26-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "36c0694bfdb776c1b966e1cbf42b6a38c5842a8e3e7d37ec3909d4fa96d16f9e"
    end
  end

  conflicts_with "zellij", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk-source", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk-rc", because: "both install a zellij binary"

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
