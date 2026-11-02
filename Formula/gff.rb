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
  url "https://github.com/noahkiss/flightdeck/releases/download/v0.0.0/gff_0.0.0_linux_amd64.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/noahkiss/flightdeck/releases/download/v0.0.0/gff_0.0.0_darwin_arm64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/noahkiss/flightdeck/releases/download/v0.0.0/gff_0.0.0_linux_arm64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    if OS.mac?
      # The darwin archive holds signed, notarized app bundles. gff-hab install finds
      # GFF Holder.app and gff beside the GFF Hab.app its own executable resolves into, and
      # copies all three out of the prefix; so they stay together in libexec and bin links in.
      libexec.install "GFF Hab.app", "GFF Holder.app", "gff"
      bin.install_symlink libexec/"gff"
      bin.install_symlink libexec/"GFF Hab.app/Contents/MacOS/gff-hab"
      bin.install_symlink libexec/"GFF Holder.app/Contents/MacOS/gff-hab-holder"
    else
      bin.install "gff", "gff-hab", "gff-hab-holder"
    end
  end

  def caveats
    <<~EOS
      To run the hab as a user service on this machine:
        gff-hab install
    EOS
  end

  test do
    %w[gff gff-hab gff-hab-holder].each do |name|
      assert_equal "#{name} #{version}", shell_output("#{bin}/#{name} --version").strip
    end
  end
end
