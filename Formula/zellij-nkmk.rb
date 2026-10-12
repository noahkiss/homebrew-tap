class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  url "https://github.com/noahkiss/zellij/archive/refs/tags/v0.45.1-nkmk.32.tar.gz"
  version "0.45.1-nkmk.32"
  sha256 "af0682c0cbd9f442057125942e3e8a679e017d280fb1cf9c5af5fbbccc0095e4"
  license "MIT"

  # Homebrew 7 loads every formula for every OS and arch when a tap is added,
  # so the formula needs a url that is valid everywhere. The source tarball is
  # that url. The prebuilt tarballs below override it on the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.32/zellij-nkmk-0.45.1-nkmk.32-aarch64-apple-darwin.tar.gz"
      sha256 "329c6a5b2ec18f94e2ae5a17be2b7f7aaf230a20e4fc6ac3499c1d95ed0c3d77"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.32/zellij-nkmk-0.45.1-nkmk.32-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f038310c1ce8387f4de69df01a777722b2ef268fbef9f5b9bb2e14b88c565974"
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
