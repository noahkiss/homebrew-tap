class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.44.3-nkmk.9"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.44.3-nkmk.9/zellij-nkmk-0.44.3-nkmk.9-aarch64-apple-darwin.tar.gz"
      sha256 "7ed052a358d6f4b24d1ee05f168ab5065f738ad9602936576fb7f2a1cf141b2f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.44.3-nkmk.9/zellij-nkmk-0.44.3-nkmk.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0b0a2a71d4ec77f799bfd9063b19a73e199534e90a07910fe6dcb1458a6af0be"
    end
  end

  conflicts_with "zellij", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk-source", because: "both install a zellij binary"

  def install
    bin.install "zellij"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zellij --version")
    system bin/"zellij", "setup", "--check"
  end
end
