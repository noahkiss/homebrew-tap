class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  url "https://github.com/noahkiss/zellij/archive/refs/tags/v0.45.1-nkmk.33.tar.gz"
  version "0.45.1-nkmk.33"
  sha256 "20a5f8deda7a0e886471ca339569402071cf90e0df3c0783c6ef576784f623b1"
  license "MIT"

  # Homebrew 7 loads every formula for every OS and arch when a tap is added,
  # so the formula needs a url that is valid everywhere. The source tarball is
  # that url. The prebuilt tarballs below override it on the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.33/zellij-nkmk-0.45.1-nkmk.33-aarch64-apple-darwin.tar.gz"
      sha256 "faccb79645c3a5ce56c3ca8cc9f4d54b5cce0f2943b9cb8da310842af5363d7d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.1-nkmk.33/zellij-nkmk-0.45.1-nkmk.33-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e36311b88a58bb834a0b7a93e359f6560cbfea520ebb51c9abd59c982db2135d"
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
