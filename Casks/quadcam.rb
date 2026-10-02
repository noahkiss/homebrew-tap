cask "quadcam" do
  version "0.5.1"
  sha256 "5ad83f1c072d2cba279b11179cc85f82cad0e8cfcf226cba60a837a16f891cdc"

  url "https://github.com/noahkiss/quadcam/releases/download/v#{version}/quadcam-#{version}-arm64.zip"
  name "quadcam"
  desc "Import analog FPV DVR clips: date, name, convert, verify, format the card"
  homepage "https://github.com/noahkiss/quadcam"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on formula: "ffmpeg"
  depends_on macos: :ventura

  app "QuadCam.app"
  binary "#{appdir}/QuadCam.app/Contents/MacOS/quadcam-cli"

  # The app has an ad-hoc signature only, with no Developer ID and no
  # notarization. Homebrew quarantines every download, and Gatekeeper blocks a
  # quarantined app that Apple did not notarize.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/QuadCam.app"]
  end

  zap trash: [
    "~/Library/Application Support/app.quadcam",
    "~/Library/Caches/app.quadcam",
    "~/Library/Saved Application State/app.quadcam.savedState",
    "~/Library/WebKit/app.quadcam",
  ]
end
