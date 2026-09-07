class Markshift < Formula
  desc "Convert between HTML, Markdown, and rich text formats"
  homepage "https://github.com/noahkiss/markshift"
  url "https://github.com/noahkiss/markshift/releases/download/v1.2.0/markshift-1.2.0.tgz"
  sha256 "b0ae7e4882cf2d25f3f04e0134074c63f35cc8efb532166af5df06165b3f5eb4"
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
