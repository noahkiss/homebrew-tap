class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  url "https://github.com/noahkiss/zellij/archive/refs/tags/v0.45.1-nkmk.20.tar.gz"
  version "0.45.1-nkmk.20"
  sha256 "a1aee57112e99e39b004f835cf9106c0ddca154f4fdffaec0c083f393afb1b6d"
  license "MIT"

  # Homebrew 7 loads every formula for every OS and arch when a tap is added,
  # so the formula needs a url that is valid everywhere. The source tarball is
  # that url. The prebuilt tarballs below override it on the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.20/zellij-nkmk-0.45.1-nkmk.20-aarch64-apple-darwin.tar.gz"
      sha256 "78b203084006df24d3cd8c13a3f66afa9c7c652e8ba1bf8482ca47ae4f91a75c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.20/zellij-nkmk-0.45.1-nkmk.20-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "98c57b150b33410fec1eb38f41586c770289bc3f453690a6bc52242a0f9da563"
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
