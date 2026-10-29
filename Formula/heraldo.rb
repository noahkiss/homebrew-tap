class Heraldo < Formula
  desc "Inbox CLI for a heraldo notification hub, and a notify-script drop-in"
  homepage "https://github.com/noahkiss/heraldo"
  url "https://github.com/noahkiss/heraldo/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "c535012f77385009445b23c09d192ef9b9f2e451ae547ae1790cf6227585f407"
  license "MIT"
  head "https://github.com/noahkiss/heraldo.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    # std_go_args adds -s -w.
    ldflags = "-X github.com/noahkiss/heraldo/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"heraldo"), "./cmd/heraldo"
  end

  test do
    assert_match "heraldo v#{version}", shell_output("#{bin}/heraldo version")
    # With no notify URL set, send does nothing, as the notify script it replaces.
    assert_empty shell_output("#{bin}/heraldo send -m x")
    assert_match "HERALDO_URL is not set", shell_output("#{bin}/heraldo ls 2>&1", 1)
  end
end
