cask "quadcam" do
  version "0.1.0"
  sha256 "ee80f0291d2c68175dd32f433de60efd1484fa708f799be93ac003bc3c377a9d"

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
