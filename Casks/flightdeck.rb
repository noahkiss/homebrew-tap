cask "flightdeck" do
  version "1.0.14-fd.0-rc.11"
  sha256 "6d55c3b2faa0a13e13df7c85102f84e5b53ccb500b4e75e01d34c2b47cd638dc"

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
