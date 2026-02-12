class Markshift < Formula
  desc "Convert between HTML, Markdown, and rich text formats"
  homepage "https://github.com/noahkiss/markshift"
  url "https://github.com/noahkiss/markshift/releases/download/v1.0.0/markshift-1.0.0.tgz"
  sha256 "09a8c2c81ed4207a2d458801fd476aaabab537f7f11bb77a1997af75fa736704"
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
