class BasicMemory < Formula
  desc "Local-first work-tracking and knowledge CLI (bm), a hard fork of basic-memory"
  homepage "https://github.com/noahkiss/basic-memory"
  url "https://github.com/noahkiss/basic-memory/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d5ad284d63a643786a6a4e2533b2cc9ec9e0389b4db3654feb3ba680caaca9fb"
  license "AGPL-3.0-or-later"

  depends_on "uv" => :build
  # 3.13 rather than 3.14: the dependency tree pulls binary wheels (onnxruntime,
  # tokenizers) whose 3.14 coverage is still incomplete.
  depends_on "python@3.13"

  def install
    # 167 locked dependencies make an enumerated-resource formula impractical, so
    # the build resolves from uv.lock over the network. Acceptable for a personal tap.
    ENV["UV_CACHE_DIR"] = buildpath/"uv-cache"
    ENV["UV_PYTHON_DOWNLOADS"] = "never"
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec
    # uv-dynamic-versioning derives the version from git; a release tarball has no
    # .git, so hand the plugin the tag directly or metadata reports 0.0.0.
    ENV["UV_DYNAMIC_VERSIONING_BYPASS"] = version.to_s

    python = formula_opt_bin("python@3.13")/"python3.13"
    system "uv", "sync", "--locked", "--no-dev", "--no-editable", "--python", python

    bin.install_symlink libexec/"bin/bm", libexec/"bin/basic-memory"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bm --version")
    assert_match "bm", shell_output("#{bin}/bm --help")
    assert_match version.to_s, shell_output("#{bin}/basic-memory --version")
  end
end
