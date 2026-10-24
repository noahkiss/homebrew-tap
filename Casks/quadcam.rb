cask "quadcam" do
  version "0.24.0"
  sha256 "b210820fbfc25e0423108c8abee2f66101746d82d03d9451350f85e98b2fdc2f"

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
