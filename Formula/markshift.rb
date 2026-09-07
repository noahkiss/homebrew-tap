class Markshift < Formula
  desc "Convert between HTML, Markdown, and rich text formats"
  homepage "https://github.com/noahkiss/markshift"
  url "https://github.com/noahkiss/markshift/releases/download/v1.0.1/markshift-1.0.1.tgz"
  sha256 "dbb39bf83c16b07a1cc814b9bb15ce34579ee717aa88679c1f5efb4520ae04f5"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/markshift --version")

    output = shell_output("echo '**bold**' | #{bin}/markshift md-to-html")
    assert_match "<strong>bold</strong>", output

    output = shell_output("echo '<p>hello</p>' | #{bin}/markshift html-to-md")
    assert_match "hello", output
  end
end
