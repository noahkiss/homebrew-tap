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
  url "https://github.com/noahkiss/flightdeck/releases/download/v0.6.0/gff_0.6.0_linux_amd64.tar.gz"
  sha256 "2da4cbad3a379f68cd6acf351032ac45e196e708065edb8e5935507ecb3290a6"
  license "MIT"

  # The Capcom engine (capcom/ in each archive) runs on Node.js; gff-hab install runs npm ci.
  depends_on "node"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/noahkiss/flightdeck/releases/download/v0.6.0/gff_0.6.0_darwin_arm64.tar.gz"
      sha256 "87644302b027ac977d93c984d051911f2c406ec550abe7423f86b5fd7f9a2987"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/noahkiss/flightdeck/releases/download/v0.6.0/gff_0.6.0_linux_arm64.tar.gz"
      sha256 "408e2ffec57270aabb0d12292ce0dc5443a90faec9b2cfb050f82ce3e6e0a98f"
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
    # The Capcom engine folder: the bundled engine and the npm manifest of its SDKs. gff-hab
    # install finds it beside GFF Hab.app (macOS) or as ../libexec/capcom from bin/gff-hab
    # (Linux), copies it into its state folder and runs npm ci there, only when [capcom] engine
    # is set. Older archives have no capcom/.
    libexec.install "capcom" if File.directory?("capcom")
  end

  def caveats
    <<~EOS
      To run the hab as a user service on this machine:
        gff-hab install
      Run it again after each `brew upgrade gff`; until then the hab keeps running the old build.
      Before `brew uninstall gff`, run `gff-hab uninstall` to stop and remove the service.

      The Capcom service is off until [capcom] engine is set in the hab's config. Then run
      `gff-hab install` again: it copies the engine and runs `npm ci`, which downloads the
      Claude Agent SDK and the Codex SDK (several hundred MB).
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
