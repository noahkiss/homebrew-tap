class Heraldo < Formula
  desc "Inbox CLI for a heraldo notification hub, and a notify-script drop-in"
  homepage "https://github.com/noahkiss/heraldo"
  url "https://github.com/noahkiss/heraldo/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "d2d1063cde8de24f3883b4612777dc0e3dd8d200243ca95d678d97f5de8e7b7e"
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
