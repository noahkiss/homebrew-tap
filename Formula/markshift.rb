class Markshift < Formula
  desc "Convert between HTML, Markdown, and rich text formats"
  homepage "https://github.com/noahkiss/markshift"
  url "https://github.com/noahkiss/markshift/releases/download/v1.1.0/markshift-1.1.0.tgz"
  sha256 "0454fb4eefa0b1f8bf0e73ecf14ca6b99bd1ce3539ff1ebb0078b7b24ae7c083"
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
