class ZellijNkmk < Formula
  desc "Personal zellij fork: plugin hot-reload, permission pre-grants, session fixes"
  homepage "https://github.com/noahkiss/zellij"
  version "0.45.0-nkmk.2"
  license "MIT"

  # Prebuilt binaries from the fork's release workflow. Only the platforms in
  # actual use — glibc linux x86_64 and mac arm64. Anything else (musl, arm64
  # Linux, intel macs) builds from zellij-nkmk-source.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.2/zellij-nkmk-0.45.0-nkmk.2-aarch64-apple-darwin.tar.gz"
      sha256 "f1223f87db8777379b9ba6c43d3a85c985e9cdbec002eff2bb8956c33bb76d15"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/noahkiss/zellij/releases/download/v0.45.0-nkmk.2/zellij-nkmk-0.45.0-nkmk.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f0987b992f7bebb5acd1dc4ea7d9177c443fcd6daa81b38cc150aca891d30e73"
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
