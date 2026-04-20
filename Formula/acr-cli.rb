class AcrCli < Formula
  desc "A CLI tool for AtCoder competitive programming in Rust"
  homepage "https://github.com/t-seki/acr"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t-seki/acr/releases/download/v0.4.4/acr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8db9b13556b8155cd0aee0ace0c94113cf73596c64bebeaf3155cf556807c9b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t-seki/acr/releases/download/v0.4.4/acr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "107f1fecac0c51b784d4f94c6defa5b1d9575da1d7f0c2efdfd5a02c0895740b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t-seki/acr/releases/download/v0.4.4/acr-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "628803e8fa53a85a0c8e0efee0247648e86a3fc37d302fbf671c5a0a66d4ebd3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t-seki/acr/releases/download/v0.4.4/acr-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e2bd39020ff8bfb0969e20f542b89608e771514df1213b5b5c439107ade4ff2a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "acr" if OS.mac? && Hardware::CPU.arm?
    bin.install "acr" if OS.mac? && Hardware::CPU.intel?
    bin.install "acr" if OS.linux? && Hardware::CPU.arm?
    bin.install "acr" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
