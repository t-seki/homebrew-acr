class AcrCli < Formula
  desc "A CLI tool for AtCoder competitive programming in Rust"
  homepage "https://github.com/t-seki/acr"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t-seki/acr/releases/download/v0.4.1/acr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5a012bb462b7818bfbcb0714f7c2a6c27b68721c084192808a1283154c82db57"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t-seki/acr/releases/download/v0.4.1/acr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "677281150bfe1eaa220277a33bb972ad5dba361bf98f431d338808a894c3b3d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t-seki/acr/releases/download/v0.4.1/acr-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc564a4c68506745f7d0efeda6c69c0a599b5017bf70128a0861805f97053aee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t-seki/acr/releases/download/v0.4.1/acr-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6186cfd9680cf80611505a1537d1c2143365fba816b1a13962823ec7cc695abe"
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
