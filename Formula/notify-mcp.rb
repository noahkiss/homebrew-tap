class NotifyMcp < Formula
  desc "MCP server that sends push notifications via Apprise"
  homepage "https://github.com/noahkiss/notify-mcp"
  url "https://github.com/noahkiss/notify-mcp/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "9fe0154b1bd0b4f79dbde5683937cbe99cd72f42d00c446041f6173b3ef575ed"
  license "MIT"
  head "https://github.com/noahkiss/notify-mcp.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      To configure notify-mcp for Claude Code, run:
        notify-mcp init
    EOS
  end

  test do
    assert_match "notify-mcp", shell_output("#{bin}/notify-mcp --help")
  end
end
