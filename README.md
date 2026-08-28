# homebrew-tap

Homebrew formulae for [sandbox](https://github.com/satishbabariya/sandbox) —
run coding agents in Apple Virtualization VMs whose network egress they cannot
bypass.

```console
$ brew install satishbabariya/tap/sandbox
$ sandbox kernel install   # guest kernel, ~280 MiB, once
$ sandbox doctor           # checks everything at once
```

Requires Apple silicon and macOS 26.

## Why it builds from source

The binary has to be codesigned with `com.apple.security.virtualization`, or
Virtualization refuses to start a VM at all. A poured bottle would arrive
without a signature macOS accepts, so the formula builds on the machine it will
run on. That costs a few minutes on first install.

## Updating

The formula is published as an asset of each
[release](https://github.com/satishbabariya/sandbox/releases), with its url and
sha256 already stamped by the release workflow. Take it from there rather than
editing this copy, so the checksum is the one that was actually built:

```console
$ gh release download <tag> --repo satishbabariya/sandbox \
    --pattern sandbox.rb --dir Formula
$ git commit -am "sandbox <version>" && git push
```
