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
  url "https://github.com/noahkiss/flightdeck/releases/download/v0.2.0/gff_0.2.0_linux_amd64.tar.gz"
  sha256 "9920d4ad0a828ce514c3d672060df8e3d7078cb8fbd302f687229a0864e237f0"
  license "MIT"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/noahkiss/flightdeck/releases/download/v0.2.0/gff_0.2.0_darwin_arm64.tar.gz"
      sha256 "7603fe4d0d08ec56b87c7edaacee9886e8ffb3446fb1fd3df25cedcc66ae9830"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/noahkiss/flightdeck/releases/download/v0.2.0/gff_0.2.0_linux_arm64.tar.gz"
      sha256 "bd7225e7e8cce905f397d43c66ed7ebaf5d983f49d8a7a6d2df1d5debf5b7014"
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
