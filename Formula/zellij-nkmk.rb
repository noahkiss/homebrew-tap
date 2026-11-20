class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  url "https://github.com/noahkiss/zellij/archive/refs/tags/v0.46.0-nkmk.42.tar.gz"
  version "0.46.0-nkmk.42"
  sha256 "ea6d9cecc1e9c6444b79c9f053e68c85262ff2289ff7d7cbbfe988f4b9072098"
  license "MIT"

  # Homebrew 7 loads every formula for every OS and arch when a tap is added,
  # so the formula needs a url that is valid everywhere. The source tarball is
  # that url. The prebuilt tarballs below override it on the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.46.0-nkmk.42/zellij-nkmk-0.46.0-nkmk.42-aarch64-apple-darwin.tar.gz"
      sha256 "cdccd1a9b916cc5776c4c4710be1331facaa5521c4f718684f5d48c6d9b95bc1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.46.0-nkmk.42/zellij-nkmk-0.46.0-nkmk.42-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "761333610a16a0f19a2237777a8039afc0797c67790b97bb64087e63e3804cf4"
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
