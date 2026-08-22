class BasicMemory < Formula
  desc "Local-first work-tracking and knowledge CLI (bm), a hard fork of basic-memory"
  homepage "https://github.com/noahkiss/basic-memory"
  url "https://github.com/noahkiss/basic-memory/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "1eef220f75a8ae6f1f2497bde456abbc42f4e0848a05887196c949cff6432198"
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
  end
end
