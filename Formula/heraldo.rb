class Heraldo < Formula
  desc "Inbox CLI for a heraldo notification hub, and a notify-script drop-in"
  homepage "https://github.com/noahkiss/heraldo"
  url "https://github.com/noahkiss/heraldo/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fd0d8e94cd0dbf28bae4213ddab89b3568e2309499e90061477febc8ac32be47"
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
