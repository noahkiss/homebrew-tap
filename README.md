# Homebrew Tap

Custom Homebrew formulas.

## Installation

```bash
brew tap noahkiss/tap
```

Newer Homebrew refuses a third-party tap until it is trusted:

```bash
brew trust noahkiss/tap
```

## Available Formulas

### basic-memory

Local-first work-tracking and knowledge CLI (`bm`), a hard fork of basic-memory.

```bash
brew install noahkiss/tap/basic-memory
```

### markshift

Convert between HTML, Markdown, and rich text formats.

```bash
brew install noahkiss/tap/markshift
```

### zellij-nkmk

Personal zellij fork, poured as a prebuilt binary (macOS arm64, Linux x86_64).
`zellij-nkmk-source` builds the same release from source for any other platform;
`zellij-nkmk-rc` tracks the release candidate currently being proved. The three
conflict with each other and with `zellij`.

```bash
brew install noahkiss/tap/zellij-nkmk
```

## How a formula gets bumped

Formulae are bumped by workflows in this repo, never by hand. Each one rewrites
the formula from the producer's release, proves it with a real `brew install`
on macOS and Linux, and only then commits.

| Formula | Workflow | Fired by |
|---|---|---|
| `markshift` | `bump.yml` | `noahkiss/markshift` release workflow, on a `v*` tag |
| `zellij-nkmk`, `zellij-nkmk-rc`, `zellij-nkmk-source` | `bump-zellij.yml` | `noahkiss/zellij` release workflow, on a `v*` tag |
| `basic-memory` | none yet | hand edit |

To bump by hand, when the producer did not fire it:

```bash
gh workflow run bump.yml -R noahkiss/homebrew-tap -f formula=markshift -f tag=v1.3.0
gh workflow run bump-zellij.yml -R noahkiss/homebrew-tap -f tag=v0.45.0-nkmk.19
```

`bump.yml` handles any formula with one `url` and one `sha256`. It derives the
new url from the old one, downloads and hashes the asset itself, and runs the
formula's `test do` block after installing. The zellij formulae have a url per
platform and a from-source twin, so they keep their own workflow.
