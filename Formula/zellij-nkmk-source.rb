class ZellijNkmkSource < Formula
  desc "Personal zellij fork, built from source (prebuilt: zellij-nkmk)"
  homepage "https://github.com/noahkiss/zellij"
  url "https://github.com/noahkiss/zellij/archive/refs/tags/v0.45.1-nkmk.27.tar.gz"
  version "0.45.1-nkmk.27"
  sha256 "629b9b91ec241a7eab9ee4706ed25b8df8439660738bece110aecd70eafd3c24"
  license "MIT"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  conflicts_with "zellij", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk", because: "both install a zellij binary"
  conflicts_with "zellij-nkmk-rc", because: "both install a zellij binary"

  def install
    if OS.linux?
      ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
      ENV["OPENSSL_NO_VENDOR"] = "1"
    end
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zellij --version")
    system bin/"zellij", "setup", "--check"
  end
end
