cask "heraldo-app" do
  version "0.10.1"
  sha256 "83670e3d8211e7f6099bf62d1b14d1ebda14dd75ad2dfee4cff36055ed7e0e7a"

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
