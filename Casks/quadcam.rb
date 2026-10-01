cask "quadcam" do
  version "0.2.1"
  sha256 "da2a668664c6bc3dd774bfa69f403d36bc3fa6f87ccf112814163c2af912e8c2"

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

  app "quadcam.app"
  binary "#{appdir}/quadcam.app/Contents/MacOS/quadcam-cli"

  # The app has an ad-hoc signature only, with no Developer ID and no
  # notarization. Homebrew quarantines every download, and Gatekeeper blocks a
  # quarantined app that Apple did not notarize.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/quadcam.app"]
  end

  zap trash: [
    "~/Library/Application Support/app.quadcam",
    "~/Library/Caches/app.quadcam",
    "~/Library/Saved Application State/app.quadcam.savedState",
    "~/Library/WebKit/app.quadcam",
  ]
end
