cask "heraldo-app" do
  version "0.2.0"
  sha256 "394842d98fe09182801e4db5cedd231c2a2c1e42df54c7363b134284a9ef2162"

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
