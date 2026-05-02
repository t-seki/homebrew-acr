class AcrCli < Formula
  desc "A CLI tool for AtCoder competitive programming in Rust"
  homepage "https://github.com/t-seki/acr"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t-seki/acr/releases/download/v0.6.1/acr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c07ee3b79bc4cae85d80593f4d02f70c05da134ec731a45f1ac8fcfb5953aac1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t-seki/acr/releases/download/v0.6.1/acr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "59330e72f4159a9be9bd7e515607bf63a988b0b959947161641c943c829a6274"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t-seki/acr/releases/download/v0.6.1/acr-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ba843c296d30feaf527250a98e680606a323b2bac6dda72aeb57ce58d0ab52b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t-seki/acr/releases/download/v0.6.1/acr-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cfad8b80e99807453211beedfa95666a47bfdae6aa734eae2135bb3866c291c6"
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
