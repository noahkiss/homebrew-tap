cask "quadcam" do
  version "0.21.3"
  sha256 "9022bbc0dd15ae45eada12297d3a34a20a24f0f2008cc33e84f778ce4500e210"

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
