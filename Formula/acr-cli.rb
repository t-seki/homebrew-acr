class AcrCli < Formula
  desc "A CLI tool for AtCoder competitive programming in Rust"
  homepage "https://github.com/t-seki/acr"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t-seki/acr/releases/download/v0.7.1/acr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c3396e727d313249d51e9b02b639f5c08a44c90c627821c42170d2def2eca6a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t-seki/acr/releases/download/v0.7.1/acr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8e005a79d33a4925c9164eda6a8e3805ee1d3d06ac59cc13815a5665e8ef4eda"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t-seki/acr/releases/download/v0.7.1/acr-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1639f8c810399b3bd2bb9ed99c99c08b9a190322efe58345df133723099582a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t-seki/acr/releases/download/v0.7.1/acr-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d26f8774017002063ba33c7c2bcb14f449b5701362898a0b041967862cc9fea"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "acr"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "acr"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "acr"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "acr"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
