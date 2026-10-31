class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  url "https://github.com/noahkiss/zellij/archive/refs/tags/v0.45.1-nkmk.40.tar.gz"
  version "0.45.1-nkmk.40"
  sha256 "fc6468d4a103e71edfe15ffd09c97f10ed51d7f6797546ea8f6994f0f811d4bb"
  license "MIT"

  # Homebrew 7 loads every formula for every OS and arch when a tap is added,
  # so the formula needs a url that is valid everywhere. The source tarball is
  # that url. The prebuilt tarballs below override it on the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.40/zellij-nkmk-0.45.1-nkmk.40-aarch64-apple-darwin.tar.gz"
      sha256 "b127a2158427297185cf8e2d77ea699801b55ebe0451ca8c1283dab3d7ab1b8a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.40/zellij-nkmk-0.45.1-nkmk.40-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ba2fed7a79dbe601304d1f2891f261efc6b488da3b0f9102f600061cf6f8f8e6"
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
