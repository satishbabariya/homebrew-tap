# Homebrew formula for sandbox.
#
# Copied from a release asset, where the url and sha256 are stamped by the
# release workflow. Do not edit those by hand: take the file from the release
# so the checksum is the one that was actually built.
#
#   gh release download <tag> --repo satishbabariya/sandbox \
#     --pattern sandbox.rb --dir Formula
#
# Builds from source rather than pouring a bottle. The binary must be
# codesigned with com.apple.security.virtualization on the machine it runs on,
# and a bottle would arrive without a signature macOS accepts.
class Sandbox < Formula
  desc "Run coding agents in sandboxes whose network egress they cannot bypass"
  homepage "https://github.com/satishbabariya/sandbox"
  url "https://github.com/satishbabariya/sandbox/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "6dff1340bdffb2d3c6999111848852ff6173dd0143e6ac1253fc7430d4a96820"
  license "Apache-2.0"
  head "https://github.com/satishbabariya/sandbox.git", branch: "main"

  depends_on arch: :arm64
  depends_on :macos
  # Package.swift declares macOS 26 as its minimum.
  depends_on macos: :tahoe
  depends_on "go" => :build

  def install
    system "make", "build", "CONFIG=release"
    bin.install ".build/release/sandbox"
    bin.install ".build/bin/gvsandbox"
    pkgshare.install "scripts/acceptance.sh"
  end

  def caveats
    <<~EOS
      Fetch a guest kernel before the first run:
        sandbox kernel install

      Then check the install:
        sandbox doctor

      sandbox needs the com.apple.security.virtualization entitlement, which is
      applied at build time. If sandboxes fail to start with an entitlement
      error, reinstall with --build-from-source.
    EOS
  end

  test do
    assert_match "sandbox", shell_output("#{bin}/sandbox --help")
    # policy check needs no VM, so it is a real end-to-end check of the
    # matcher without requiring virtualization in the test sandbox.
    assert_match "deny", shell_output("#{bin}/sandbox policy check evil.com 2>&1", 1)
    assert_match "allow", shell_output("#{bin}/sandbox policy check example.com --allow example.com")
  end
end
