class NotifyMcp < Formula
  desc "MCP server that sends push notifications via Apprise"
  homepage "https://github.com/noahkiss/notify-mcp"
  url "https://github.com/noahkiss/notify-mcp/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "66d8b0110be41ca057d647905c9aad2f53e6ebede05056109368a47be35f6f9e"
  license "MIT"
  head "https://github.com/noahkiss/notify-mcp.git", branch: "main"

  depends_on "go" => :build

  def install
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
