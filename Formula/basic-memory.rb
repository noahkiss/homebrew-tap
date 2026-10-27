class BasicMemory < Formula
  desc "Local-first work-tracking and knowledge CLI (bm), a hard fork of basic-memory"
  homepage "https://github.com/noahkiss/basic-memory"
  # The source tarball and the bottles live on this tap's own release,
  # basic-memory-<version>, not on the source repository. That repository is
  # private, so its archive url answers 404 to anyone. bottle.yml checks the tag
  # out with a read-only deploy key, publishes a `git archive` of it here, builds
  # the bottles from it and writes url, sha256 and the bottle block together.
  # A machine no bottle covers builds from this tarball with no credential. Do
  # not bump by hand: dispatch bottle.yml with the new tag.
  url "https://github.com/noahkiss/homebrew-tap/releases/download/basic-memory-0.2.21/basic-memory-0.2.21.tar.gz"
  sha256 "179f01a6f49fa1c245d042ef2771d6d0f0d450f2c747f058fefa74eac52d3191"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/noahkiss/homebrew-tap/releases/download/basic-memory-0.2.21"
    sha256                               arm64_golden_gate: "0dffbb084a0a32815c834a9933293502f6544406c9c10d1b6f78e8b1bc938a1e"
    sha256                               arm64_tahoe:       "464a884427700aada3cb16f0109733fbbc35745f999bfeccd01166d92a515944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "38ae9c27ce14fe0b1eb3a79c177d65facd804ff55de2ef085060453ce03457e9"
  end

  depends_on "uv" => :build
  # 3.13 rather than 3.14: the dependency tree pulls binary wheels (onnxruntime,
  # tokenizers) whose 3.14 coverage is still incomplete.
  depends_on "python@3.13"

  def install
    # The locked dependency tree makes an enumerated-resource formula impractical, so
    # the build resolves from uv.lock over the network. Acceptable for a personal tap.
    ENV["UV_CACHE_DIR"] = buildpath/"uv-cache"
    ENV["UV_PYTHON_DOWNLOADS"] = "never"
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec
    # uv-dynamic-versioning derives the version from git. The release tarball
    # carries no .git, so without the bypass the build would report 0.0.0; the
    # bypass pins the reported version to the formula's.
    ENV["UV_DYNAMIC_VERSIONING_BYPASS"] = version.to_s

    python = formula_opt_bin("python@3.13")/"python3.13"
    # Core plus the server extra. A client runs `bm mcp` (fastmcp), and local mode
    # (cutover, rollback) routes project changes through the in-process FastAPI
    # app and serves `bm web`. The embeddings and format extras stay out: semantic
    # search runs on the bm server, and format_on_save is off by default.
    system "uv", "sync", "--locked", "--no-dev", "--no-editable", "--extra", "server",
           "--python", python

    bin.install_symlink libexec/"bin/bm", libexec/"bin/basic-memory"

    relocate_macho_dylib_ids if OS.mac?
  end

  # Trigger: on macOS, Homebrew post-install runs fix_dynamic_linkage, which
  # rewrites the LC_ID_DYLIB of every MH_DYLIB Mach-O in the keg to its absolute
  # opt path.
  # Why: Rust/maturin wheels ship Python extension modules as MH_DYLIB carrying a
  # short "@rpath/..." id and no header padding. The longer opt path does not fit,
  # ruby-macho raises, and that raise aborts the whole relocation loop, so every
  # file after the first offender is left unrelocated. There is no formula-level
  # opt-out; skip_relocation applies to bottles only.
  # Outcome: do the rewrite here first. Where it fits, Homebrew later sees
  # id == target and skips the file. Where it does not fit, demote the file to
  # MH_BUNDLE, the historical and correct filetype for a Python extension module,
  # which Homebrew skips via its "if file.dylib?" guard. Only a file nothing loads
  # by name can reach that branch: a real shared library would have failed
  # Homebrew's own rewrite too, so odie reports it rather than silently breaking it.
  def relocate_macho_dylib_ids
    require "macho"

    # Built with pack, not a literal: a raw "\xCF..." string is invalid UTF-8 and
    # crashes `brew audit`'s FormulaAudit/PythonVersions cop when it scans strings.
    mh_magic_64 = [0xfeedfacf].pack("V")
    mh_bundle = [8].pack("V")

    libexec.glob("**/*.{so,dylib}").each do |file|
      next if file.symlink?

      macho = begin
        MachO.open(file)
      rescue MachO::MachOError
        next
      end

      dylib_id = macho.dylib_id
      next if dylib_id.nil?

      want = (opt_libexec/file.relative_path_from(libexec)).to_s
      next if dylib_id == want

      if quiet_system("install_name_tool", "-id", want, file)
        codesign_adhoc file
        next
      end

      # No headerpad. Demote to MH_BUNDLE instead. dyld rejects a bundle that still
      # carries LC_ID_DYLIB, reporting "found LC_ID_DYLIB found in non-MH_DYLIB", so
      # drop that load command first, then flip the filetype word at bytes 12..15
      # from MH_DYLIB (6) to MH_BUNDLE (8). Thin little-endian 64-bit Mach-O only;
      # a fat or big-endian file would need per-slice edits and must not be mangled.
      if File.binread(file, 4) != mh_magic_64
        odie "#{file}: dylib id does not fit and this is not a thin 64-bit Mach-O"
      end

      macho.delete_command(macho[:LC_ID_DYLIB].first)
      macho.write!
      file.open("r+b") do |io|
        io.seek(12)
        io.write(mh_bundle)
      end
      codesign_adhoc file
    end
  end

  # Editing a Mach-O invalidates its ad-hoc signature, and arm64 will not load an
  # unsigned image.
  def codesign_adhoc(file)
    return if quiet_system("codesign", "--force", "--sign", "-", file)

    odie "codesign failed for #{file}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bm --version")
    assert_match "bm", shell_output("#{bin}/bm --help")
    assert_match version.to_s, shell_output("#{bin}/basic-memory --version")
    # The server extra is installed, and the embeddings extra is not.
    system libexec/"bin/python", "-c", "import fastapi, fastmcp, jinja2, uvicorn"
    shell_output("#{libexec}/bin/python -c 'import fastembed'", 1)
  end
end
