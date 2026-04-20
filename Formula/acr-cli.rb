class AcrCli < Formula
  desc "A CLI tool for AtCoder competitive programming in Rust"
  homepage "https://github.com/t-seki/acr"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t-seki/acr/releases/download/v0.5.0/acr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "50c7e7a4a6b5a7e03f9852f46f392b0aebdf16e11085d0cc31c38d17dabca970"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t-seki/acr/releases/download/v0.5.0/acr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e2025802e7ed7cb61d6eb663c0a8b71209b6ca00ab06a6a37f3c0ceed05cc13a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t-seki/acr/releases/download/v0.5.0/acr-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7b0022c94850bfb9b8bd2d7c743541e2e545a6977243f086f2d47962db7b1207"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t-seki/acr/releases/download/v0.5.0/acr-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9fed7d495a398726b7cd6eece2a207c5c918c47336775eb6e42859d475492be6"
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
