cask "artcraft-launcher" do
  version "0.4.1"
  sha256 "baff6237e544a22a0045faa4a095aeee0a7d2d4f14d389704ce41d3ae75c1267"

  url "https://github.com/storytold/craft-launcher/releases/download/v#{version}/artcraft-launcher-#{version}-macos-universal.dmg"
  name "ArtCraft Launcher"
  desc "Install, update and open the Craft App Suite"
  homepage "https://github.com/storytold/craft-launcher"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The launcher updates itself ("Update and restart"). `brew upgrade` skips it;
  # `brew upgrade --cask --greedy artcraft-launcher` still updates it through Homebrew.
  auto_updates true
  depends_on :macos

  app "ArtCraft Launcher.app"

  zap trash: [
    "~/Library/Application Support/ArtCraft Launcher",
    "~/Library/Caches/ai.storyteller.artcraft-launcher",
    "~/Library/Preferences/ai.storyteller.artcraft-launcher.plist",
    "~/Library/Saved Application State/ai.storyteller.artcraft-launcher.savedState",
  ]
end
