cask "heraldo-app" do
  version "0.10.6"
  sha256 "0722611c0dc76a6ebf2e5ac919b21fc20d40b7beabf16491e7529817ab8745e0"

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
