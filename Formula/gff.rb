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
  url "https://github.com/noahkiss/flightdeck/releases/download/v0.1.0/gff_0.1.0_linux_amd64.tar.gz"
  sha256 "3162628b8355d8822704f7cc249f262b1b812a100a31762ec2037f94ccdc8e4a"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/noahkiss/flightdeck/releases/download/v0.1.0/gff_0.1.0_darwin_arm64.tar.gz"
      sha256 "c4911ed946185061b1255ede61d4bf33e719e82012824edc38dbbbf0d2e33d4b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/noahkiss/flightdeck/releases/download/v0.1.0/gff_0.1.0_linux_arm64.tar.gz"
      sha256 "bb81249b083cd708636ebfee6054a889b9b4d17b8483eb8b0215cf196c0552e0"
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
