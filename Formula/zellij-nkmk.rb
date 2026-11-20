class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  url "https://github.com/noahkiss/zellij/archive/refs/tags/v0.46.0-nkmk.41.tar.gz"
  version "0.46.0-nkmk.41"
  sha256 "b2d9b28ace364d51f8e267dbd256df6bf322664e451f36225a1777be00ca76c4"
  license "MIT"

  # Homebrew 7 loads every formula for every OS and arch when a tap is added,
  # so the formula needs a url that is valid everywhere. The source tarball is
  # that url. The prebuilt tarballs below override it on the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.46.0-nkmk.41/zellij-nkmk-0.46.0-nkmk.41-aarch64-apple-darwin.tar.gz"
      sha256 "4358a363605e7d6ef5213be9c8be1f1435bddc6808e70a793f67368145045f26"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.46.0-nkmk.41/zellij-nkmk-0.46.0-nkmk.41-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "06d9c903938154325458574b00e84a764d584f017b0bf6f28d4fdcf58a4b52c0"
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
