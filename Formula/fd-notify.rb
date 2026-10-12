class FdNotify < Formula
  desc "Send encrypted push notifications to FlightDeck through nkmk-push"
  homepage "https://github.com/noahkiss/homebrew-tap"
  url "https://github.com/noahkiss/homebrew-tap/releases/download/fd-notify-0.3.1/fd-notify-0.3.1-x86_64-unknown-linux-gnu.tar.gz"
  sha256 "5b152c07a15a2b2cf0ae658396b77fc5cede6fd32f5bf106adb56e0e15dacf7e"

  # The source repository is private, so the prebuilt tarballs live on this
  # tap's release fd-notify-<version>; bump-fd-notify.yml rewrites them.
  # Homebrew 7 loads every formula for every OS and arch, so the top-level url
  # (linux x86_64) is valid everywhere; mac arm64 and linux arm64 override it.
  # An Intel Mac would get the linux binary, so install refuses there.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/homebrew-tap/releases/download/fd-notify-0.3.1/fd-notify-0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "6c16646c19370b38eecdd4b09f83f35d4659ebd87220abf5b1039430ff46bce4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/noahkiss/homebrew-tap/releases/download/fd-notify-0.3.1/fd-notify-0.3.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f253928dfb41c47471bce56ede5773b731fb2aee0eaaf1b172b05a6dd22c39a0"
    end
  end

  def install
    odie "no prebuilt fd-notify for Intel Macs" if OS.mac? && Hardware::CPU.intel?
    bin.install "fd-notify"
  end

  test do
    assert_equal "fd-notify #{version}", shell_output("#{bin}/fd-notify version").strip
    # status --json reads the config only; it needs no network and no pairing.
    ENV["ROOTSHELL_PUSH_CONFIG"] = testpath/"config.json"
    assert_match "\"version\":\"#{version}\"", shell_output("#{bin}/fd-notify status --json")
  end
end
