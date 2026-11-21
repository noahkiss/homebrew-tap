class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  url "https://github.com/noahkiss/zellij/archive/refs/tags/v0.46.0-nkmk.43.tar.gz"
  version "0.46.0-nkmk.43"
  sha256 "e6e916685c7834145dc0d821122cf3b5dc5d227d4683772547266dfe98f600c5"
  license "MIT"

  # Homebrew 7 loads every formula for every OS and arch when a tap is added,
  # so the formula needs a url that is valid everywhere. The source tarball is
  # that url. The prebuilt tarballs below override it on the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.46.0-nkmk.43/zellij-nkmk-0.46.0-nkmk.43-aarch64-apple-darwin.tar.gz"
      sha256 "89de89cc5ed5af64197f77da2fe9f0d3efbebe21c0efae41e82064a5baef24c1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.46.0-nkmk.43/zellij-nkmk-0.46.0-nkmk.43-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d698746a067c294de7dc02566d97c8c1a5bcfeca1e0f85918eb5219ffae7185b"
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
