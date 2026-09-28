class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  url "https://github.com/noahkiss/zellij/archive/refs/tags/v0.45.1-nkmk.23.tar.gz"
  version "0.45.1-nkmk.23"
  sha256 "bc432a8bf4a9f7768c8acda37ca854abb7da67707523582bfb53877f533f6a2b"
  license "MIT"

  # Homebrew 7 loads every formula for every OS and arch when a tap is added,
  # so the formula needs a url that is valid everywhere. The source tarball is
  # that url. The prebuilt tarballs below override it on the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.23/zellij-nkmk-0.45.1-nkmk.23-aarch64-apple-darwin.tar.gz"
      sha256 "91c9c60f79352285f4468f4a785bfcf5de0df5edffd61fa52d5b0425537aa527"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.23/zellij-nkmk-0.45.1-nkmk.23-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cfd225c02d0baba72a73bb696e69097f3dd9880dd8a793c08fd3f2f8dfa7ed4b"
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
