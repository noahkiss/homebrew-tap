cask "heraldo-app" do
  version "0.3.2"
  sha256 "392e5ffb7c5059c62e839e17f962aa3736fdc8148464438ee0fc3c87adc7cb60"

  url "https://github.com/noahkiss/heraldo/releases/download/v#{version}/Heraldo-#{version}-macos.zip"
  name "Heraldo"
  desc "Menu bar app and inbox for a heraldo notification hub"
  homepage "https://github.com/noahkiss/heraldo"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sequoia

  app "Heraldo.app"

  zap trash: [
    "~/Library/Containers/com.nkmkdigital.heraldo",
    "~/Library/Containers/com.nkmkdigital.heraldo.widgets",
    "~/Library/Group Containers/group.com.nkmkdigital.heraldo",
  ]
end
