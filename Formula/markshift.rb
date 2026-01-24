class Markshift < Formula
  desc "Suite of tools for converting text to and from Markdown format"
  homepage "https://github.com/noahkiss/markshift"
  url "https://registry.npmjs.org/markshift/-/markshift-0.0.1.tgz"
  sha256 "PLACEHOLDER_SHA256"
  license "MIT"
  head "https://github.com/noahkiss/markshift.git", branch: "main"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  def caveats
    <<~EOS
      Clipboard support on Linux requires X11.

      For Debian/Ubuntu:
        sudo apt install xorg-dev libxcb-composite0-dev

      For Fedora:
        sudo dnf install libX11-devel libxcb-devel

      Wayland users should enable XWayland for clipboard functionality.
    EOS
  end

  test do
    # Test CLI runs
    assert_match version.to_s, shell_output("#{bin}/markshift --version")

    # Test basic markdown to HTML conversion
    output = shell_output("echo '**bold**' | #{bin}/markshift md-to-html")
    assert_match "<strong>bold</strong>", output

    # Test HTML to markdown conversion
    output = shell_output("echo '<p>hello</p>' | #{bin}/markshift html-to-md")
    assert_match "hello", output
  end
end
