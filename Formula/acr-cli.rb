class AcrCli < Formula
  desc "A CLI tool for AtCoder competitive programming in Rust"
  homepage "https://github.com/t-seki/acr"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t-seki/acr/releases/download/v0.7.0/acr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7f334edc7d58e15dc5dc5f013322e3be6a0a8bbf878e79f7c399476ff1c89ef5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t-seki/acr/releases/download/v0.7.0/acr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7a3ce6a8414b8396693f734cb668338036efe874875e3bba0dbeebcc669bf353"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t-seki/acr/releases/download/v0.7.0/acr-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c10e11cb4b27c93eb57704f4200a26bf7ad34fc5768a2fa3db604dbf85221bd0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t-seki/acr/releases/download/v0.7.0/acr-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dbaa8c74fffdf4a6e0616fb413bb12d6949ae27ccd755b2c13bfae2c95750c55"
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
