class FdNotify < Formula
  desc "Send encrypted push notifications to FlightDeck through nkmk-push"
  homepage "https://github.com/noahkiss/homebrew-tap"
  url "https://github.com/noahkiss/homebrew-tap/releases/download/fd-notify-0.3.2/fd-notify-0.3.2-x86_64-unknown-linux-gnu.tar.gz"
  sha256 "a4c3eee8b264b95de354e7818485d2fbe6ba1f726a13adb98975459742a0b84c"

  # The source repository is private, so the prebuilt tarballs live on this
  # tap's release fd-notify-<version>; bump-fd-notify.yml rewrites them.
  # Homebrew 7 loads every formula for every OS and arch, so the top-level url
  # (linux x86_64) is valid everywhere; mac arm64 and linux arm64 override it.
  # An Intel Mac would get the linux binary, so install refuses there.
  on_macos do
    on_arm do
      url "https://github.com/noahkiss/homebrew-tap/releases/download/fd-notify-0.3.2/fd-notify-0.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "9907c1d64869bd83314952a8b5b15fe81b92c63abc0fbe73014c21994a89120e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/noahkiss/homebrew-tap/releases/download/fd-notify-0.3.2/fd-notify-0.3.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1e2ccd407c84efce1f41d417fa43d6849f103c4b946ac3a05636d68c5a3ad587"
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
