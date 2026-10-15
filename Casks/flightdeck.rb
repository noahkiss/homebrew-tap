cask "flightdeck" do
  version "1.0.14-fd.0-rc.9"
  sha256 "ef7dbf05aa87a37ec831534eacb42d790ca98c423805537cc574bc1958cb0464"

  url "https://github.com/noahkiss/flightdeck/releases/download/v#{version}/flightdeck-v#{version}-macos.zip"
  name "FlightDeck"
  desc "Terminal and SSH client, a personal build of rootshell"
  homepage "https://github.com/noahkiss/flightdeck"

  # Every release is a prerelease, so read the app's own Sparkle feed.
  livecheck do
    url "https://raw.githubusercontent.com/noahkiss/flightdeck/appcast/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "FlightDeck.app"

  zap trash: [
    "~/Library/Application Support/com.nkmkdigital.flightdeck.rootshell",
    "~/Library/Caches/com.nkmkdigital.flightdeck.rootshell",
    "~/Library/Group Containers/group.com.nkmkdigital.flightdeck",
    "~/Library/HTTPStorages/com.nkmkdigital.flightdeck.rootshell",
    "~/Library/Preferences/com.nkmkdigital.flightdeck.rootshell*.plist",
    "~/Library/Saved Application State/com.nkmkdigital.flightdeck.rootshell.savedState",
    "~/Library/WebKit/com.nkmkdigital.flightdeck.rootshell",
  ]
end
