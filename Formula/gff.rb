class Gff < Formula
  desc "Flightdeck's terminal client and per-host server for coding agents"
  homepage "https://github.com/noahkiss/flightdeck"
  # Homebrew loads every formula for every OS and arch, so the top-level url must hold
  # everywhere: it is the linux amd64 asset. Each other platform overrides it below. There is
  # no Intel Mac build; depends_on stops the install there.
  #
  # The version in these urls is a placeholder until flightdeck's first final v* tag, which
  # dispatches bump.yml to rewrite every url and sha256 from the release's assets. Keep the
  # version out of comments: bump.yml refuses a rewrite that leaves the old one in the file.
  url "https://github.com/noahkiss/flightdeck/releases/download/v0.3.0/gff_0.3.0_linux_amd64.tar.gz"
  sha256 "febec22dffc8c4eed6e79840eedafc18cba92362756d8abbf032d8f776254403"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/noahkiss/flightdeck/releases/download/v0.3.0/gff_0.3.0_darwin_arm64.tar.gz"
      sha256 "1a37b3f619d3dc4d43b7be3c8cafac26ab7c24bf6c6df164904dfe708d695074"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/noahkiss/flightdeck/releases/download/v0.3.0/gff_0.3.0_linux_arm64.tar.gz"
      sha256 "0d9fc3743c030810f12d3dcfff6c2cac24cde64f100bd7234c8ee946fe699b1a"
    end
  end

  def install
    if OS.mac?
      # The darwin archive holds signed, notarized app bundles. gff-hab install finds
      # GFF Holder.app and gff beside the GFF Hab.app its own executable resolves into, and
      # copies all three out of the prefix; so they stay together in libexec and bin links in.
      # The holder runs only from its bundle, so it gets no link.
      libexec.install "GFF Hab.app", "GFF Holder.app", "gff"
      bin.install_symlink libexec/"gff"
      bin.install_symlink libexec/"GFF Hab.app/Contents/MacOS/gff-hab"
    else
      bin.install "gff", "gff-hab", "gff-hab-holder"
    end
  end

  def caveats
    <<~EOS
      To run the hab as a user service on this machine:
        gff-hab install
      Run it again after each `brew upgrade gff`; until then the hab keeps running the old build.
      Before `brew uninstall gff`, run `gff-hab uninstall` to stop and remove the service.
    EOS
  end

  test do
    holder = if OS.mac?
      libexec/"GFF Holder.app/Contents/MacOS/gff-hab-holder"
    else
      bin/"gff-hab-holder"
    end
    { "gff" => bin/"gff", "gff-hab" => bin/"gff-hab", "gff-hab-holder" => holder }.each do |name, path|
      assert_equal "#{name} #{version}", shell_output("'#{path}' --version").strip
    end
  end
end
