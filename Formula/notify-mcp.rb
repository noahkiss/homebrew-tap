class NotifyMcp < Formula
  desc "MCP server that sends push notifications via Apprise"
  homepage "https://github.com/noahkiss/notify-mcp"
  url "https://github.com/noahkiss/notify-mcp/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "e7d991a391bbc63f61a018c39ef4454fff20e16fb9837a6f3a3c833aa5ecdc3d"
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
