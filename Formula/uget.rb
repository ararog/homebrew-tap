class Uget < Formula
  desc "A minimal cli tool to make http requests. You want, you get!"
  homepage "https://ararog.github.io/uget"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ararog/uget/releases/download/0.1.5/uget-aarch64-apple-darwin.tar.xz"
      sha256 "593ad9d2f5137cf0d71fbe006e6e7bf84ec94205da4d7661fb8db4e03c5f6210"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ararog/uget/releases/download/0.1.5/uget-x86_64-apple-darwin.tar.xz"
      sha256 "70b517688f8b618360a154f731ba733bb6120a280c73e76c382d545b94a058f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ararog/uget/releases/download/0.1.5/uget-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b90252b72d732604324335547e4983cdc5320b0575c0160ee4a33ab98df7fb46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ararog/uget/releases/download/0.1.5/uget-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1af51b8866120ed0bfb4a175a2565abf5c4cf0c35a8ec0718a76371664be5dc2"
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
    bin.install "uget" if OS.mac? && Hardware::CPU.arm?
    bin.install "uget" if OS.mac? && Hardware::CPU.intel?
    bin.install "uget" if OS.linux? && Hardware::CPU.arm?
    bin.install "uget" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
