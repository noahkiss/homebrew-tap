cask "quadcam" do
  version "0.21.2"
  sha256 "2608a730004d41f75735aaa1d3144ff22643247943ab4639eed606d8561c58e7"

  url "https://github.com/noahkiss/quadcam/releases/download/v#{version}/quadcam-#{version}-arm64.zip"
  name "quadcam"
  desc "Import FPV video clips and manage radios, quads, sims and voice packs"
  homepage "https://github.com/noahkiss/quadcam"

  livecheck do
    url :url
    strategy :github_latest
  end

  # QuadCam updates itself (tauri-plugin-updater). `brew upgrade` skips it;
  # `brew upgrade --cask --greedy quadcam` still updates it through Homebrew.
  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :ventura

  app "QuadCam.app"
  binary "#{appdir}/QuadCam.app/Contents/MacOS/quadcam-cli"

  zap trash: [
    "~/Library/Application Support/app.quadcam",
    "~/Library/Caches/app.quadcam",
    "~/Library/Saved Application State/app.quadcam.savedState",
    "~/Library/WebKit/app.quadcam",
  ]
end
