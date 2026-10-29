cask "heraldo-app" do
  version "0.9.0"
  sha256 "d4370e222ab5f04c95a6c8e02cb560545aadfd9804899f3dffcf02ff3d90ac81"

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
