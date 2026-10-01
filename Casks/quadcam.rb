cask "quadcam" do
  version "0.4.0"
  sha256 "cabc4f5a612cd9fe15519b981a2320157339fb627a7901cfcab81437068218eb"

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
